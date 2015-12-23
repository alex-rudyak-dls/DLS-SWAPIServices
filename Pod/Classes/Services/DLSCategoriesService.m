//
//  DLSCategoriesService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSCategoriesService.h"
#import <PromiseKit/PromiseKit.h>
#import <Underscore.m/Underscore.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiConstants.h"
#import "DLSCategoryObject.h"
#import "DLSCategoryWrapper.h"
#import "DLSAuthenticationService.h"


@implementation DLSCategoriesService

- (PMKPromise *)fetchAll
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        [self updateMediumPaths];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchAllWithParams:nil];
    }).thenOn(self.fetchQueue, ^(id response) {
        NSArray<DLSCategoryObject *> *categories = [EKMapper arrayOfObjectsFromExternalRepresentation:response withMapping:[DLSCategoryObject objectMapping]];
        if (!categories.count) {
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
        [realm addOrUpdateObjectsFromArray:categories];
        [realm commitWriteTransaction];

        NSArray<DLSCategoryWrapper *> *wrappers = [Underscore array](categories).map(^(DLSCategoryObject *category) {
            return [DLSCategoryWrapper categoryWithObject:category];
        }).unwrap;
        return [PMKPromise promiseWithValue:wrappers];
    }).thenOn(self.responseQueue, ^(NSArray *categories) {
        [self _successWithResponse:categories completion:nil];
        return [PMKPromise promiseWithValue:categories];
    });
}

#pragma mark - Helpers

- (void)updateMediumPaths
{
    [self.transport updateMediumPathIdentifiers:@{
        DLSPathOrganisationEntityId : self.organisationId
    }];
}

@end
