//
//  DLSOrganisationsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSOrganisationsService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSOrganisationObject.h"
#import "DLSOrganisationWrapper.h"
#import "DLSAuthenticationService.h"


@implementation DLSOrganisationsService

- (PMKPromise *)fetchById:(id)identifier
{
    return [super fetchById:identifier].thenOn(self.fetchQueue, ^() {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchWithId:identifier];
    }).thenOn(self.fetchQueue, ^(id response) {
        DLSOrganisationObject *organisation = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSOrganisationObject objectMapping]];
        if (!organisation) {
            [self _successWithResponse:nil completion:nil];
            return [PMKPromise promiseWithValue:nil];
        }

        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            [self _failWithError:error inMethod:_cmd completion:nil];
            @throw error;
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:organisation];
        [realm commitWriteTransaction];

        DLSOrganisationWrapper *wrapper = [DLSOrganisationWrapper organisationWithObject:organisation];
        return [PMKPromise promiseWithValue:wrapper];
    }).thenOn(self.responseQueue, ^(DLSOrganisationWrapper *organisation) {
        [self _successWithResponse:organisation completion:nil];
        return [PMKPromise promiseWithValue:organisation];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

- (PMKPromise *)fetchAll
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchAllWithParams:nil];
    }).thenOn(self.fetchQueue, ^(id response) {
        NSArray<DLSOrganisationObject *> *organisations = [EKMapper arrayOfObjectsFromExternalRepresentation:response withMapping:[DLSOrganisationObject objectMapping]];
        if (!organisations.count) {
            [self _successWithResponse:@[] completion:nil];
            return [PMKPromise promiseWithValue:@[]];
        }

        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            [self _failWithError:error inMethod:_cmd completion:nil];
            @throw error;
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:organisations];
        [realm commitWriteTransaction];

        NSArray<DLSOrganisationWrapper *> *wrappers = _.array(organisations).map(^(DLSOrganisationObject *category) {
            return [DLSOrganisationWrapper organisationWithObject:category];
        }).unwrap;
        return [PMKPromise promiseWithValue:wrappers];
    }).thenOn(self.responseQueue, ^(NSArray *organisations) {
        [self _successWithResponse:organisations completion:nil];
        return [PMKPromise promiseWithValue:organisations];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

@end
