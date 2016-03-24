//
//  DLSCategoriesService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSCategoriesService.h"
#import <Underscore.m/Underscore.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiConstants.h"
#import "DLSCategoryObject.h"
#import "DLSCategoryWrapper.h"
#import "DLSAuthenticationService.h"


@implementation DLSCategoriesService

- (BFTask *)bft_fetchAll
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSError *error;
        RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error inMethod:_cmd];
        }

        RLMResults *const categories = [DLSCategoryObject allObjectsInRealm:realm];
        NSMutableArray<DLSCategoryWrapper *> *const categoriesWrappers = [NSMutableArray arrayWithCapacity:categories.count];
        if (categories.count) {
            for (DLSCategoryObject *category in categories) {
                [categoriesWrappers addObject:[DLSCategoryWrapper categoryWithObject:category]];
            }
            return [self _successWithResponse:[NSArray arrayWithArray:categoriesWrappers]];
        }

        [self updateMediumPaths];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSCategoryObject *> *const categories = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSCategoryObject objectMapping]];
        if (!categories.count) {
            return [self _successWithResponse:@[]];
        }

        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            return [self _failWithError:error inMethod:_cmd];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:categories];
        [realm commitWriteTransaction];

        NSArray<DLSCategoryWrapper *> *const wrappers = [Underscore array](categories).map(^(DLSCategoryObject *category) {
            return [DLSCategoryWrapper categoryWithObject:category];
        }).unwrap;
        return wrappers;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

#pragma mark - Helpers

- (void)updateMediumPaths
{
    [self.transport updateMediumPathIdentifiers:@{
        DLSPathOrganisationEntityId : self.organisationId
    }];
}

@end
