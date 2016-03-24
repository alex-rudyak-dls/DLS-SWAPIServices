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

- (BFTask<DLSUserProfileWrapper *> *)bft_fetchUserProfile
{
    if (!self.authService.isAuthorized) {
        NSError *const domainError = [NSError errorUnauthorizedAccessWithInfo:@{ NSLocalizedDescriptionKey : @"Cannot get user info profile" }];
        return [BFTask taskWithError:domainError];
    }

    NSString *const userId = self.authService.credentials.username;
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (!error) {
            DLSUserProfileObject *const user = [DLSUserProfileObject objectInRealm:realm forPrimaryKey:userId];
            if (user) {
                DLSUserProfileWrapper *const wrapper = [DLSUserProfileWrapper userWithObject:user];
                return [self _successWithResponse:wrapper];
            }
        }

        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error inMethod:_cmd];
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
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask<DLSUserProfileWrapper *> *)bft_updateUserProfile:(DLSUserProfileWrapper *)userProfile
{
    return [[BFTask taskFromExecutor:self.fetchExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error inMethod:_cmd];
        }

        @try {
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:[userProfile userProfileObject]];
            [realm commitWriteTransaction];
        }
        @catch(NSException *exception) {
            [realm cancelWriteTransaction];
        }

        return [self _successWithResponse:userProfile];
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

@end
