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
#import "DLSUserProfileService.h"
#import "DLSApplicationSettingsService.h"
#import "DLSConfigurable.h"
#import "DLSRealmFactory.h"
#import "DLSAccessTokenWrapper.h"
#import "DLSUserProfileObject.h"
#import "DLSUserProfileWrapper.h"
#import "DLSApplicationSettingsWrapper.h"
#import "DLSAuthCredentials.h"
#import "DLSAccessTokenWrapper.h"
#import "DLSServiceConfiguration.h"


NSString *const DLSAuthTokenPathKey = @"token";
NSString *const DLSAuthLogoutPathKey = @"logout";

static NSString *const kDLSAuthScope = @"openid";
static NSString *const kDLSAuthGrantType = @"password";
static NSString *const kDLSAuthRefreshGrantType = @"refresh_token";


@implementation DLSOAuthConfiguration

- (instancetype)initWithClientId:(NSString *)aClientId clientSecret:(NSString *)aClientSecret
{
    self = [super init];
    if (!self) {
        _clientId = aClientId;
        _clientSecret = aClientSecret;
    }
    return self;
}

@end

@interface DLSAuthenticationService () <DLSConfigurable>

@property (nonatomic, strong) DLSAccessTokenWrapper *token;
@property (nonatomic, strong) DLSOAuthConfiguration *oauthConfiguration;
@property (nonatomic, strong) dispatch_queue_t authorizationQueue;
@property (nonatomic, strong) BFExecutor *authorizationExecutor;
@property (nonatomic, strong) BFExecutor *completionExecutor;
@property (nonatomic, strong) id<DLSConfigurable> configurableWrapper;

@end


@implementation DLSAuthenticationService
@dynamic authorized;

#pragma mark Accessors

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration oauth:(DLSOAuthConfiguration *)anOAuthConfiguration
{
    self = [super init];
    if (self) {
        _serviceConfiguration = configuration;
        _oauthConfiguration = anOAuthConfiguration;
        _configurableWrapper = [[DLSRealmFactory alloc] initWithConfiguration:configuration];
        _authorizationQueue = dispatch_queue_create("uk.co.digitallifesciences.AuthService", DISPATCH_QUEUE_SERIAL);
        _authorizationExecutor = [BFExecutor executorWithDispatchQueue:self.authorizationQueue];
        _completionExecutor = [BFExecutor defaultExecutor];

    }
    return self;
}

- (BOOL)isAuthorized
{
    return [self.token isValid];
}

- (BFTask *)authWithCredentials:(DLSAuthCredentials *)credentials
{
    NSParameterAssert(credentials);

    _credentials = [credentials copy];

    if (credentials.username.length == 0 || credentials.password.length == 0) {
        NSError *const error = [NSError errorWithDomainPostfix:@"auth.credentials" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{ NSLocalizedDescriptionKey : @"Username or password are empty." }];

        return [BFTask taskWithError:error];
    }

    id<DLSTransport> const authorizeTransport = self.transports[DLSAuthTokenPathKey];

    return [[[[authorizeTransport create:@{
                                               @"grant_type" : kDLSAuthGrantType,
                                               @"scope" : kDLSAuthScope,
                                               @"client_id" : self.oauthConfiguration.clientId,
                                               @"client_secret" : self.oauthConfiguration.clientSecret,
                                               @"username" : self.credentials.username,
                                               @"password" : self.credentials.password
                                               }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAccessTokenObject *token = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAccessTokenObject objectMapping]];
        self.token = [DLSAccessTokenWrapper tokenWithObject:token];

        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:token];
        [realm commitWriteTransaction];

        return [self.appSettingsService fetchCurrentAppSettings];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask<DLSApplicationSettingsWrapper *> * _Nonnull task) {
        task.result.lastLoggedInUsername = self.credentials.username;
        task.result.lastStartupDate = [NSDate date];

        return [self.appSettingsService updateSettings:task.result];
    }] continueWithExecutor:self.authorizationExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted) {
            if (task.error) {
                DDLogDebug(@"[AuthService:Authentication:error] %@", [task.error localizedDescription]);
            } else if (task.exception) {
                DDLogDebug(@"[AuthService:Authentication:exception] %@", [task.exception debugDescription]);
            }

            NSException *const exceptionObj = task.exception;
            if (exceptionObj) {
                NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.exception" code:DLSSouthWorcestershireErrorCodeUnknown userInfo:@{ NSLocalizedDescriptionKey: @"Something goes wrong with data received from server. Please try again a bit later.", NSUnderlyingErrorKey: task.error }];

                return [BFTask taskWithError:domainError];
            } else if (task.error) {
                NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.error" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{ NSLocalizedDescriptionKey: task.error.localizedDescription, NSUnderlyingErrorKey: task.error }];

                return [BFTask taskWithError:domainError];
            }
        } else if (task.isCancelled) {
            return [BFTask cancelledTask];
        }
        return nil;
    }];
}

- (BFTask *)restoreAuth
{
    return [[[[self.appSettingsService fetchCurrentAppSettings] continueWithSuccessBlock:^id _Nullable(BFTask<DLSApplicationSettingsWrapper *> * _Nonnull task) {
        _credentials = [DLSAuthCredentials new];
        _credentials.username = task.result.lastLoggedInUsername;
        return [self loadExistedTokens];
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

            return [BFTask taskWithError:domainError];
        }

        DLSAccessTokenWrapper *const invalidToken = [task.result firstObject];

        return [self refreshToken:invalidToken];
    }] continueWithExecutor:self.authorizationExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted) {
            NSError *const domainError = [NSError errorWithDomainPostfix:@"auth.token.cannotrefresh" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{NSLocalizedDescriptionKey: @"Refresh token operation was finished with errors", NSUnderlyingErrorKey: task.error ?: (task.exception ?: [NSNull null])}];

            return [BFTask taskWithError:domainError];
        } else if (task.isCancelled) {
            return [BFTask cancelledTask];
        }
        return nil;
    }];
}

- (BFTask *)checkToken
{
    return [[BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        if (!self.token.isValid) {
            return [self refreshToken:self.token];
        } else {
            return self.token;
        }
    }] continueWithExecutor:self.authorizationExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.result) {
            return nil;
        }

        NSError *const domainError = [NSError errorUnauthorizedAccessWithInfo:@{NSLocalizedDescriptionKey: @"Token is invalid to use", NSUnderlyingErrorKey: task.error ?: task.exception ?: [NSNull null]}];

        return [BFTask taskWithError:domainError];
    }];
}

- (BFTask<DLSAccessTokenWrapper *> *)refreshToken:(DLSAccessTokenWrapper *)invalidToken
{
    return [[BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        id<DLSTransport> const createTransport = self.transports[DLSAuthTokenPathKey];

        return [createTransport create:@{
                                             @"grant_type": kDLSAuthRefreshGrantType,
                                             @"refresh_token": invalidToken.refreshToken,
                                             @"client_id": self.oauthConfiguration.clientId,
                                             @"client_secret": self.oauthConfiguration.clientSecret
                                             }];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAccessTokenObject *const token = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAccessTokenObject objectMapping]];

        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
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

- (BFTask *)logout
{
    if (!self.isAuthorized) {
        return nil;
    }

    self.token = nil;
    return [[[BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
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

        return [self.appSettingsService fetchCurrentAppSettings];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask<DLSApplicationSettingsWrapper *> * _Nonnull task) {
        [task.result setTermsOfUseAccepted:NO];

        return [self.appSettingsService updateSettings:task.result];
    }] continueWithExecutor:self.authorizationExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return nil;
    }];
}

#pragma mark - Helpers

- (BFTask<NSArray<DLSAccessTokenWrapper *> *> *)loadExistedTokens
{
    return [BFTask taskFromExecutor:self.authorizationExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        RLMResults *const accessTokens = [DLSAccessTokenObject allObjectsInRealm:realm];
        NSMutableArray<DLSAccessTokenWrapper *> *const arrayTokens = [NSMutableArray arrayWithCapacity:accessTokens.count];
        for(DLSAccessTokenObject *obj in accessTokens) {
            [arrayTokens addObject:[DLSAccessTokenWrapper tokenWithObject:obj]];
        }

        return [NSArray arrayWithArray:arrayTokens];
    }];
}

- (RLMRealm *)realmInstance:(NSError *__autoreleasing *)error
{
    return [self.configurableWrapper realmInstance:error];
}

@end
