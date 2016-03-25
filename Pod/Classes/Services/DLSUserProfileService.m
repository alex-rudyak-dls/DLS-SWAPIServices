//
//  DLSUserProfileService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSUserProfileService.h"
#import "DLSAuthenticationService.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiErrors.h"
#import "DLSAuthCredentials.h"
#import "DLSUserProfileObject.h"
#import "DLSUserProfileWrapper.h"
#import "DLSAccessTokenWrapper.h"


@implementation DLSUserProfileService

- (BFTask<DLSUserProfileWrapper *> *)fetchUserProfile
{
    if (!self.authService.isAuthorized) {
        NSError *const domainError = [NSError errorUnauthorizedAccessWithInfo:@{ NSLocalizedDescriptionKey : @"Cannot get user info profile" }];
        return [BFTask taskWithError:domainError];
    }

    NSString *const userId = self.authService.credentials.username;
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (!error) {
            DLSUserProfileObject *const user = [DLSUserProfileObject objectInRealm:realm forPrimaryKey:userId];
            if (user) {
                DLSUserProfileWrapper *const wrapper = [DLSUserProfileWrapper userWithObject:user];

                return wrapper;
            }
        }

        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        DLSUserProfileObject *const userProfile = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSUserProfileObject objectMapping]];
        @try {
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:userProfile];
            [realm commitWriteTransaction];
        }
        @catch (NSException *exception) {
            [realm cancelWriteTransaction];
        }

        DLSUserProfileWrapper *const wrapper = [DLSUserProfileWrapper userWithObject:userProfile];

        return wrapper;
    }];
}

- (BFTask<DLSUserProfileWrapper *> *)updateUserProfile:(DLSUserProfileWrapper *)userProfile
{
    return [BFTask taskFromExecutor:self.fetchExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        @try {
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:[userProfile userProfileObject]];
            [realm commitWriteTransaction];
        }
        @catch(NSException *exception) {
            [realm cancelWriteTransaction];
        }

        return userProfile;
    }];
}

@end
