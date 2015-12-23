//
//  DLSUserProfileService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSUserProfileService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSAuthenticationService.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiErrors.h"
#import "DLSUserProfileObject.h"
#import "DLSUserProfileWrapper.h"


@implementation DLSUserProfileService

- (PMKPromise *)fetchUserProfile
{
    if (!self.authService.isAuthorized) {
        return [PMKPromise promiseWithValue:[NSError errorUnauthorizedAccessWithInfo:@{ NSLocalizedDescriptionKey : @"Cannot get user info profile" }]];
    }

    NSString *const userId = self.authService.credentials.username;
    return [self fetchById:userId].thenOn(self.fetchQueue, ^() {
        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            [self _failWithError:error inMethod:_cmd completion:nil];
            @throw error;
        }

        DLSUserProfileObject *user = [DLSUserProfileObject objectInRealm:realm forPrimaryKey:self.authService.credentials.username];
        if (user) {
            DLSUserProfileWrapper *wrapper = [DLSUserProfileWrapper userWithObject:user];
            [self _successWithResponse:wrapper completion:nil];
            return [PMKPromise promiseWithValue:wrapper];
        }

        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchAllWithParams:nil].thenOn(self.fetchQueue, ^(NSDictionary *response) {
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:nil];
                @throw error;
            }

            DLSUserProfileObject *userProfile = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSUserProfileObject objectMapping]];
            @try {
                [realm beginWriteTransaction];
                [realm addOrUpdateObject:userProfile];
                [realm commitWriteTransaction];
            }
            @catch (NSException *exception) {
                [realm cancelWriteTransaction];
            }

            DLSUserProfileWrapper *wrapper = [DLSUserProfileWrapper userWithObject:userProfile];
            [self _successWithResponse:wrapper completion:nil];
            return [PMKPromise promiseWithValue:wrapper];
        }).catchOn(self.fetchQueue, ^(NSError *error) {
            [self _failWithError:error completion:nil];
            @throw error;
        });
    });
}

- (PMKPromise *)updateUserProfile:(DLSUserProfileWrapper *)userProfile
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(self.fetchQueue, ^{
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:resolve];
                return;
            }

            @try {
                [realm beginWriteTransaction];
                [realm addOrUpdateObject:[userProfile userProfileObject]];
                [realm commitWriteTransaction];
            }
            @catch(NSException *exception) {
                [realm cancelWriteTransaction];
            }

            [self _successWithResponse:userProfile completion:resolve];
        });
    }];
}

@end
