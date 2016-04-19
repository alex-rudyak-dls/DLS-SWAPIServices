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
#import "DLSAuthenticationService.h"
#import "DLSCategoryObject.h"
#import "DLSCategoryWrapper.h"
#import "DLSAccessTokenWrapper.h"


@implementation DLSCategoriesService

- (BFTask *)fetchAll
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        RLMResults *const categories = [DLSCategoryObject allObjectsInRealm:realm];
        NSMutableArray<DLSCategoryWrapper *> *const categoriesWrappers = [NSMutableArray arrayWithCapacity:categories.count];
        if (categories.count) {
            for (DLSCategoryObject *category in categories) {
                [categoriesWrappers addObject:[DLSCategoryWrapper categoryWithObject:category]];
            }

            return [NSArray arrayWithArray:categoriesWrappers];
        }

        [self updateMediumPaths];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [[self.transport fetchAllWithParams:nil] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
            NSArray<DLSCategoryObject *> *const categories = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSCategoryObject objectMapping]];
            if (!categories.count) {
                return @[];
            }

            NSError *error;
            RLMRealm *const realm = [self realmInstance:&error];
            if (error) {
                return [BFTask taskWithError:error];
            }

            [realm beginWriteTransaction];
            [realm addOrUpdateObjectsFromArray:categories];
            [realm commitWriteTransaction];

            NSArray<DLSCategoryWrapper *> *const wrappers = [Underscore array](categories).map(^(DLSCategoryObject *category) {
                return [DLSCategoryWrapper categoryWithObject:category];
                
            }).unwrap;
            
            return wrappers;
        }];
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
