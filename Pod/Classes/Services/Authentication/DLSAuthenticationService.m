//
//  DLSAuthenticationService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAuthenticationService.h"
#import <Underscore.m/Underscore.h>
#import <Bolts/Bolts.h>
#import "DLSPrivateHeader.h"
#import "DLSApiErrors.h"
#import "DLSApiConstants.h"
#import "DLSAccessTokenWrapper.h"
#import "DLSUserProfileObject.h"
#import "DLSUserProfileWrapper.h"
#import "DLSApplicationSettingsWrapper.h"


NSString *const DLSAuthTokenPathKey = @"token";
NSString *const DLSAuthLogoutPathKey = @"logout";

static NSString *const kDLSAuthScope = @"openid";
static NSString *const kDLSAuthCliendId = @"sw";
static NSString *const kDLSAuthClientSecret = @"m8qc9n16pdwkgwc4kg44cs0w4wsss8w";
static NSString *const kDLSAuthGrantType = @"password";
static NSString *const kDLSAuthRefreshGrantType = @"refresh_token";


@interface DLSAuthenticationService ()

@property (nonatomic, strong) DLSAccessTokenWrapper *token;
@property (nonatomic, strong) dispatch_queue_t authorizationQueue;
@property (nonatomic, strong) BFExecutor *authorizationExecutor;
@property (nonatomic, strong) BFExecutor *completionExecutor;

@end


@implementation DLSAuthenticationService
@dynamic authorized;

#pragma mark Accessors

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration
{
    self = [super init];
    if (self) {
        _serviceConfiguration = configuration;
        self.authorizationQueue = dispatch_queue_create("uk.co.digitallifesciences.AuthService", DISPATCH_QUEUE_SERIAL);
        self.authorizationExecutor = [BFExecutor executorWithDispatchQueue:self.authorizationQueue];
        self.completionExecutor = [BFExecutor defaultExecutor];
    }
    return self;
}

- (BOOL)isAuthorized
{
    return [self.token isValid];
}

- (BFTask *)bft_authWithCredentials:(DLSAuthCredentials *)credentials
{
    NSParameterAssert(credentials);

    _credentials = [credentials copy];

    if (credentials.username.length == 0 || credentials.password.length == 0) {
        NSError *const error = [NSError errorWithDomainPostfix:@"auth.credentials" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{ NSLocalizedDescriptionKey : @"Username or password are empty." }];
        return [BFTask taskWithError:error];
    }

    id<DLSTransport> const authorizeTransport = self.transports[DLSAuthTokenPathKey];

    return [[[[authorizeTransport bft_create:@{
                                               @"grant_type" : kDLSAuthGrantType,
                                               @"scope" : kDLSAuthScope,
                                               @"client_id" : kDLSAuthCliendId,
                                               @"client_secret" : kDLSAuthClientSecret,
                                               @"username" : self.credentials.username,
                                               @"password" : self.credentials.password
                                               }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAccessTokenObject *token = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAccessTokenObject objectMapping]];
        self.token = [DLSAccessTokenWrapper tokenWithObject:token];

        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:token];
        [realm commitWriteTransaction];

        return [self.appSettingsService bft_fetchCurrentAppSettings];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask<DLSApplicationSettingsWrapper *> * _Nonnull task) {
        task.result.lastLoggedInUsername = self.credentials.username;
        task.result.lastStartupDate = [NSDate date];
        return [self.appSettingsService bft_updateSettings:task.result];
    }] continueWithExecutor:self.completionExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted) {
            if (task.error) {
                DDLogDebug(@"[AuthService:Authentication:error] %@", [task.error localizedDescription]);
            } else if (task.exception) {
                DDLogDebug(@"[AuthService:Authentication:exception] %@", [task.exception debugDescription]);
            }

            NSException *const exceptionObj = task.exception;
            if (exceptionObj) {
                NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.exception" code:DLSSouthWorcestershireErrorCodeUnknown userInfo:@{NSLocalizedDescriptionKey: @"Something goes wrong with data received from server. Please try again a bit later.", NSUnderlyingErrorKey: task.error}];
                return [self _failWithError:domainError];
            } else if (task.error) {
                NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.error" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{}];
                return [self _failWithError:domainError];
            }
        } else if (task.isCancelled) {
            return [BFTask cancelledTask];
        }
        return nil;
    }];
}

- (BFTask *)bft_restoreAuth
{
    return [[[[self.appSettingsService bft_fetchCurrentAppSettings] continueWithSuccessBlock:^id _Nullable(BFTask<DLSApplicationSettingsWrapper *> * _Nonnull task) {
        _credentials = [DLSAuthCredentials new];
        _credentials.username = task.result.lastLoggedInUsername;
        return [self bft_loadExistedTokens];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask<NSArray<DLSAccessTokenWrapper *> *> * _Nonnull task) {
        DLSAccessTokenWrapper *const validToken = [Underscore array](task.result).filter(^BOOL (DLSAccessTokenWrapper *token) {
            return token.isValid;
        }).first;
        if (validToken) {
            self.token = validToken;
            return nil;
        }

        if (!task.result.count) {
            NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.token.notfound" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{NSLocalizedDescriptionKey: @"No valid token found"}];
            return [self _failWithError:domainError];
        }

        DLSAccessTokenWrapper *const invalidToken = [task.result firstObject];
        return [self bft_refreshToken:invalidToken];
    }] continueWithExecutor:self.authorizationExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted) {
            NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.token.cannotrefresh" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{NSLocalizedDescriptionKey: @"Refresh token operation was finished with errors", NSUnderlyingErrorKey: task.error ?: (task.exception ?: [NSNull null])}];
            return [self _failWithError:domainError];
        } else if (task.isCancelled) {
            return [BFTask cancelledTask];
        }
        return nil;
    }];
}

- (BFTask *)bft_checkToken
{
    return [[BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        if (!self.token.isValid) {
            return [self bft_refreshToken:self.token];
        } else {
            return self.token;
        }
    }] continueWithExecutor:self.authorizationExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.result) {
            return [self _successWithResult:nil];
        }

        NSError *const domainError = [NSError errorUnauthorizedAccessWithInfo:@{NSLocalizedDescriptionKey: @"Token is invalid to use", NSUnderlyingErrorKey: task.error ?: task.exception ?: [NSNull null]}];

        return [self _failWithError:domainError];
    }];
}

- (BFTask<DLSAccessTokenWrapper *> *)bft_refreshToken:(DLSAccessTokenWrapper *)invalidToken
{
    return [[BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        id<DLSTransport> const createTransport = self.transports[DLSAuthTokenPathKey];
        return [createTransport bft_create:@{
                                             @"grant_type": kDLSAuthRefreshGrantType,
                                             @"refresh_token": invalidToken.refreshToken,
                                             @"client_id": kDLSAuthCliendId,
                                             @"client_secret": kDLSAuthClientSecret
                                             }];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAccessTokenObject *const token = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAccessTokenObject objectMapping]];

        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        DLSAccessTokenObject *const invalidTokenObject = [DLSAccessTokenObject objectInRealm:realm forPrimaryKey:invalidToken.accessToken];
        [realm beginWriteTransaction];
        [realm deleteObject:invalidTokenObject];
        [realm addOrUpdateObject:token];
        [realm commitWriteTransaction];

        self.token = [DLSAccessTokenWrapper tokenWithObject:token];

        return self.token;
    }];
}

- (BFTask *)bft_logout
{
    if (!self.isAuthorized) {
        return [self _successWithResult:nil];
    }

    self.token = nil;
    return [[[BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error];
        }

        RLMResults *const tokenObjs = [DLSAccessTokenObject allObjectsInRealm:realm];
        if (tokenObjs.count) {
            @try {
                [realm beginWriteTransaction];
                [realm deleteObjects:tokenObjs];
                [realm commitWriteTransaction];
            }
            @catch (NSException *exception) {
                [realm cancelWriteTransaction];
            }
        }

        return [self.appSettingsService bft_fetchCurrentAppSettings];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask<DLSApplicationSettingsWrapper *> * _Nonnull task) {
        [task.result setTermsOfUseAccepted:NO];
        return [self.appSettingsService bft_updateSettings:task.result];
    }] continueWithExecutor:self.completionExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return nil;
    }];
}

#pragma mark - Helpers

- (BFTask<NSArray<DLSAccessTokenWrapper *> *> *)bft_loadExistedTokens
{
    return [BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        RLMResults *const accessTokens = [DLSAccessTokenObject allObjectsInRealm:realm];
        NSMutableArray<DLSAccessTokenWrapper *> *const arrayTokens = [NSMutableArray arrayWithCapacity:accessTokens.count];
        for(DLSAccessTokenObject *obj in accessTokens) {
            [arrayTokens addObject:[DLSAccessTokenWrapper tokenWithObject:obj]];
        }

        return [BFTask taskWithResult:[NSArray arrayWithArray:arrayTokens]];
    }];
}

- (BFTask *)_failWithError:(NSError *)error
{
    return [BFTask taskFromExecutor:self.completionExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithError:error];
    }];
}

- (BFTask *)_successWithResult:(id)result
{
    return [BFTask taskFromExecutor:self.completionExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithResult:result];
    }];
}

@end


@implementation DLSAuthCredentials

- (instancetype)initWithCompletion:(void (^)(DLSAuthCredentials *))completion
{
    self = [super init];
    if (self && completion) {
        completion(self);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DLSAuthCredentials *copyInstance = [[DLSAuthCredentials alloc] initWithCompletion:^(DLSAuthCredentials *credentials) {
        credentials.username = [self.username copy];
        credentials.password = [self.password copy];
    }];
    return copyInstance;
}

@end
