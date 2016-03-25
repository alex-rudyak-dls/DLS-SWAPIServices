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
#import "DLSAccessTokenWrapper.h"


@implementation DLSOrganisationsService

- (BFTask *)fetchAll
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSOrganisationObject *> *const organisations = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSOrganisationObject objectMapping]];
        if (!organisations.count) {
            return @[];
        }

        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObjectsFromArray:organisations];
        [realm commitWriteTransaction];

        NSArray<DLSOrganisationWrapper *> *const wrappers = [Underscore array](organisations).map(^(DLSOrganisationObject *category) {
            return [DLSOrganisationWrapper organisationWithObject:category];
        }).unwrap;

        return wrappers;
    }];
}

- (BFTask *)fetchById:(id)identifier
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport fetchWithId:identifier];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSOrganisationObject *const organisation = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSOrganisationObject objectMapping]];
        if (!organisation) {
            return @[];
        }

        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:organisation];
        [realm commitWriteTransaction];

        DLSOrganisationWrapper *const wrapper = [DLSOrganisationWrapper organisationWithObject:organisation];

        return wrapper;
    }];
}

@end
