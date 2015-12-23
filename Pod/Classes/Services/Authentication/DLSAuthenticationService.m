//
//  DLSAuthenticationService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAuthenticationService.h"
#import <PromiseKit/PromiseKit.h>
#import <UIKit/UIKit.h>
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


@interface DLSAuthenticationService () <UIWebViewDelegate>

@property (nonatomic, strong) DLSAccessTokenWrapper *token;
@property (nonatomic, strong) dispatch_queue_t authorizationQueue;

@end


@implementation DLSAuthenticationService
@dynamic authorized;

#pragma mark Accessors

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration
{
    self = [super init];
    if (self) {
        _serviceConfiguration = configuration;
        self.authorizationQueue = dispatch_queue_create("uk.co.digitallifesciences.AuthService", 0);
    }
    return self;
}

- (BOOL)isAuthorized
{
    return [self.token isValid];
}

- (PMKPromise *)authWithCredentials:(DLSAuthCredentials *)credentials
{
    NSParameterAssert(credentials);

    _credentials = [credentials copy];

    if (credentials.username.length == 0 || credentials.password.length == 0) {
        NSError *error = [NSError errorWithDomainPostfix:@"auth.credentials" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{ NSLocalizedDescriptionKey : @"Username or password are empty." }];
        return [PMKPromise promiseWithValue:error];
    }

    id<DLSTransport> autorizeTransport = self.transports[DLSAuthTokenPathKey];
    return [autorizeTransport create:@{
        @"grant_type" : kDLSAuthGrantType,
        @"scope" : kDLSAuthScope,
        @"client_id" : kDLSAuthCliendId,
        @"client_secret" : kDLSAuthClientSecret,
        @"username" : self.credentials.username,
        @"password" : self.credentials.password
    }].thenOn(self.authorizationQueue, ^(id response) {
        DLSAccessTokenObject *token = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSAccessTokenObject objectMapping]];
        self.token = [DLSAccessTokenWrapper tokenWithObject:token];

        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            @throw error;
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:token];
        [realm commitWriteTransaction];

        return [self.appSettingsService fetchCurrentAppSettings].then(^(DLSApplicationSettingsWrapper *appSettings) {
            appSettings.lastLoggedInUsername = self.credentials.username;
            appSettings.lastStartupDate = [NSDate date];
            return [self.appSettingsService updateSettings:appSettings];
        }).then(^() {
            return @YES;
        });
    }).catch(^(NSError *error) {
        DDLogDebug(@"[AuthService:Authentication] %@", [error localizedDescription]);

        NSException *const exceptionObj = error.userInfo[PMKUnderlyingExceptionKey];
        if (exceptionObj) {
            NSError *domainError = [NSError errorWithDomainPostfix:@"auth.exception" code:DLSSouthWorcestershireErrorCodeUnknown userInfo:@{NSLocalizedDescriptionKey: @"Something goes wrong with data received from server. Please try again a bit later.", NSUnderlyingErrorKey: error}];
            @throw domainError;
        } else {
            @throw error;
        }
    });
}

- (PMKPromise *)restoreAuth
{
    return [self.appSettingsService fetchCurrentAppSettings].thenOn(self.authorizationQueue, ^(DLSApplicationSettingsWrapper *appSettings) {
        _credentials = [DLSAuthCredentials new];
        _credentials.username = appSettings.lastLoggedInUsername;
        return [self loadExistedTokens];
    }).thenOn(self.authorizationQueue, ^(NSArray<DLSAccessTokenWrapper *> *accessTokens) {
        DLSAccessTokenWrapper *validToken = _.array(accessTokens).filter(^BOOL (DLSAccessTokenWrapper *token) {
            return token.isValid;
        }).first;
        if (validToken) {
            self.token = validToken;
            return [PMKPromise promiseWithValue:@YES];
        }

        if (!accessTokens.count) {
            @throw [NSError errorWithDomainPostfix:@"auth.token.notfound" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{NSLocalizedDescriptionKey: @"No valid token found"}];
        }

        DLSAccessTokenWrapper *invalidToken = [accessTokens firstObject];
        return [self refreshToken:invalidToken].thenOn(self.authorizationQueue, ^(DLSAccessTokenWrapper *token) {
            return @YES;
        }).catchOn(self.authorizationQueue, ^(NSError *error) {
            @throw [NSError errorWithDomainPostfix:@"auth.token.cannotrefresh" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:@{NSLocalizedDescriptionKey: @"Refresh token operation was finished with errors", NSUnderlyingErrorKey: error}];
        });
    });
}

- (PMKPromise *)checkToken
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        if (!self.token.isValid) {
            resolve([self refreshToken:self.token]);
        } else {
            resolve(self.token);
        }
    }].then(^(DLSAccessTokenWrapper *token) {
        if (token) {
            return @YES;
        }
        @throw [NSError errorUnauthorizedAccessWithInfo:@{NSLocalizedDescriptionKey: @"Token is invalid to use"}];
    });
}

- (PMKPromise *)refreshToken:(DLSAccessTokenWrapper *)invalidToken
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(self.authorizationQueue, ^{
            id<DLSTransport> createTransport = self.transports[DLSAuthTokenPathKey];
            [createTransport create:@{
                                      @"grant_type": kDLSAuthRefreshGrantType,
                                      @"refresh_token": invalidToken.refreshToken,
                                      @"client_id": kDLSAuthCliendId,
                                      @"client_secret": kDLSAuthClientSecret
                                      }].thenOn(self.authorizationQueue, ^(id response) {
                DLSAccessTokenObject *token = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSAccessTokenObject objectMapping]];

                NSError *error;
                RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
                if (error) {
                    resolve(error);
                    return;
                }

                DLSAccessTokenObject *invalidTokenObject = [DLSAccessTokenObject objectInRealm:realm forPrimaryKey:invalidToken.accessToken];
                [realm beginWriteTransaction];
                [realm deleteObject:invalidTokenObject];
                [realm addOrUpdateObject:token];
                [realm commitWriteTransaction];

                self.token = [DLSAccessTokenWrapper tokenWithObject:token];
                resolve(self.token);
            });
        });
    }];
}

- (PMKPromise *)logout
{
    if (!self.isAuthorized) {
        return [PMKPromise promiseWithValue:@YES];
    }

    self.token = nil;
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            resolve(error);
            return;
        }

        RLMResults *tokenObjs = [DLSAccessTokenObject allObjectsInRealm:realm];
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

        [self.appSettingsService fetchCurrentAppSettings].thenOn(self.authorizationQueue, ^(DLSApplicationSettingsWrapper *appSettings) {
            [appSettings setTermsOfUseAccepted:NO];
            return [self.appSettingsService updateSettings:appSettings];
        }).then(^() {
            resolve(@YES);
        });
    }];
}

#pragma mark - Helpers

- (PMKPromise *)loadExistedTokens
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return resolve(error);
        }

        RLMResults *accessTokens = [DLSAccessTokenObject allObjectsInRealm:realm];
        NSMutableArray<DLSAccessTokenWrapper *> *arrayTokens = [NSMutableArray arrayWithCapacity:accessTokens.count];
        for(DLSAccessTokenObject *obj in accessTokens) {
            [arrayTokens addObject:[DLSAccessTokenWrapper tokenWithObject:obj]];
        }

        resolve([NSArray arrayWithArray:arrayTokens]);
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
