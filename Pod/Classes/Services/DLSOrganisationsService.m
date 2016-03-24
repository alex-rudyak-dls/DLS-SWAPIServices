//
//  DLSOrganisationsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSOrganisationsService.h"
#import <Underscore.m/Underscore.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSOrganisationObject.h"
#import "DLSOrganisationWrapper.h"
#import "DLSAuthenticationService.h"


@implementation DLSOrganisationsService

- (BFTask *)bft_fetchAll
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSOrganisationObject *> *const organisations = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSOrganisationObject objectMapping]];
        if (!organisations.count) {
            return [self _successWithResponse:@[]];
        }

        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error inMethod:_cmd];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:organisations];
        [realm commitWriteTransaction];

        NSArray<DLSOrganisationWrapper *> *const wrappers = [Underscore array](organisations).map(^(DLSOrganisationObject *category) {
            return [DLSOrganisationWrapper organisationWithObject:category];
        }).unwrap;

        return wrappers;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask *)bft_fetchById:(id)identifier
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchWithId:identifier];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSOrganisationObject *const organisation = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSOrganisationObject objectMapping]];
        if (!organisation) {
            return [self _successWithResponse:@[]];
        }

        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error inMethod:_cmd];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:organisation];
        [realm commitWriteTransaction];

        DLSOrganisationWrapper *const wrapper = [DLSOrganisationWrapper organisationWithObject:organisation];
        return wrapper;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

@end
