//
//  DLSPracticesService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticesService.h"
#import <PromiseKit/PromiseKit.h>
#import <Underscore.m/Underscore.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiConstants.h"
#import "DLSPracticeObject.h"
#import "DLSPracticeWrapper.h"
#import "DLSPracticeShortWrapper.h"
#import "DLSPracticeWrapperFactory.h"
#import "DLSAuthenticationService.h"


@implementation DLSPracticesService

- (PMKPromise *)fetchAll
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        return [self fetchPracticesSorted:DLSPracticesListSortDefault];
    });
}

- (PMKPromise *)fetchById:(id)identifier
{
    return [super fetchById:identifier].thenOn(self.fetchQueue, ^() {
        return [self fetchById:identifier withWrappersFactory:[DLSPracticeWrapperAbstractFactory new]];
    });
}

- (PMKPromise *)fetchPracticesSorted:(DLSPracticesListSort)sortKey
{
    return [self fetchPracticesSorted:sortKey withWrapperFactory:[DLSPracticeWrapperAbstractFactory new]];
}

- (PMKPromise *)fetchPracticesPreviewSorted:(DLSPracticesListSort)sortKey
{
    return [self fetchPracticesSorted:sortKey withWrapperFactory:[DLSPracticeShortWrapperAbstractFactory new]];
}

- (PMKPromise *)fetchAllPracticePreviews
{
    return [self fetchPracticesPreviewSorted:DLSPracticesListSortDefault];
}

#pragma mark - Helpers

- (PMKPromise *)fetchById:(id)identifier withWrappersFactory:(id<DLSPracticeWrapperFactory>)wrapperFactory
{
    return [super fetchById:identifier].thenOn(self.fetchQueue, ^() {
        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            [self _failWithError:error inMethod:_cmd completion:nil];
            @throw error;
        }

        DLSPracticeObject *practice = [DLSPracticeObject objectInRealm:realm forPrimaryKey:identifier];
        if (practice) {
            id practiceWrapper = [wrapperFactory practiceWithObject:practice];
            [self _successWithResponse:practiceWrapper completion:nil];
            return [PMKPromise promiseWithValue:practiceWrapper];
        }

        [self updateMediumPaths];
        id<DLSTransport> const transport = self.entityTransport;
        [transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [transport fetchWithId:identifier].thenOn(self.fetchQueue, ^(id response) {
            DLSPracticeObject *practice = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSPracticeObject objectMapping]];
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:nil];
                @throw error;
            }

            [realm beginWriteTransaction];
            [realm addOrUpdateObject:practice];
            [realm commitWriteTransaction];
            return [PMKPromise promiseWithValue:[wrapperFactory practiceWithObject:practice]];
        });
    }).thenOn(self.responseQueue, ^(id practice) {
        [self _successWithResponse:practice completion:nil];
        return [PMKPromise promiseWithValue:practice];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

- (PMKPromise *)fetchPracticesSorted:(DLSPracticesListSort)sortKey withWrapperFactory:(id<DLSPracticeWrapperFactory>)wrapperFactory
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        NSError *error;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
        if (error) {
            [self _failWithError:error inMethod:_cmd completion:nil];
            @throw error;
        }

        RLMResults *practices = [DLSPracticeObject allObjectsInRealm:realm];
        if (practices.count) {
            practices = [practices sortedResultsUsingDescriptors:@[[self sortDescriptorForKey:sortKey]]];
            NSMutableArray<DLSPracticeWrapper *> *wrappers = [NSMutableArray arrayWithCapacity:practices.count];
            for (DLSPracticeObject *practice in practices) {
                [wrappers addObject:[wrapperFactory practiceWithObject:practice]];
            }
            [self _successWithResponse:wrappers completion:nil];
            return [PMKPromise promiseWithValue:[NSArray arrayWithArray:wrappers]];
        }

        [self updateMediumPaths];
        id<DLSTransport> const transport = self.listTransport;
        [transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [transport fetchAllWithParams:nil].thenOn(self.fetchQueue, ^(id response) {
            NSArray<DLSPracticeObject *> *practices = [EKMapper arrayOfObjectsFromExternalRepresentation:response withMapping:[DLSPracticeObject objectMapping]];
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:nil];
                @throw error;
            }

            [realm beginWriteTransaction];
            [realm addOrUpdateObjectsFromArray:practices];
            [realm commitWriteTransaction];

            practices = [practices sortedArrayUsingDescriptors:@[[self nssortDescriptorForKey:sortKey]]];
            NSArray<DLSPracticeWrapper *> *wrappers = [Underscore array](practices).map(^(DLSPracticeObject *practice) {
                return [wrapperFactory practiceWithObject:practice];
            }).unwrap;
            return [PMKPromise promiseWithValue:wrappers];
        });
    }).thenOn(self.responseQueue, ^(NSArray *practices) {
        [self _successWithResponse:practices completion:nil];
        return [PMKPromise promiseWithValue:practices];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

- (PMKPromise *)fetchPracticesPreviewWhichIsOnlyPartOfHub:(BOOL)isOnlyPartOfHub
{
    const DLSPracticesListSort sortAction = DLSPracticesListSortAlphabetically;
    if (!isOnlyPartOfHub) {
        return [self fetchPracticesPreviewSorted:sortAction];
    }

    return [self fetchPracticesPreviewSorted:DLSPracticesListSortAlphabetically].thenOn(self.responseQueue, ^(NSArray<DLSPracticeShortWrapper *> *practices) {
        return [PMKPromise promiseWithValue:[Underscore array](practices).filter(^ BOOL(DLSPracticeShortWrapper *practice) {
            return practice.isPartOfHub;
        }).unwrap];
    });
}

#pragma mark - Descriptors

- (RLMSortDescriptor *)sortDescriptorForKey:(DLSPracticesListSort)sortKey
{
    switch (sortKey) {
        case DLSPracticesListSortAlphabetically: {
            return [RLMSortDescriptor sortDescriptorWithProperty:@"name" ascending:YES];
        }
        case DLSPracticesListSortByLocation:
        default: {
            return [RLMSortDescriptor sortDescriptorWithProperty:@"country" ascending:YES];
        }
    }
}

- (NSSortDescriptor *)nssortDescriptorForKey:(DLSPracticesListSort)sortKey
{
    switch (sortKey) {
        case DLSPracticesListSortAlphabetically: {
            return [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        }
        case DLSPracticesListSortByLocation:
        default: {
            return [NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES];
        }
    }
}

#pragma mark - Helpers

- (void)updateMediumPaths
{
    NSDictionary *updatedMediumPath = @{
        DLSPathOrganisationEntityId : self.organisationId
    };
    [self.listTransport updateMediumPathIdentifiers:updatedMediumPath];
    [self.entityTransport updateMediumPathIdentifiers:updatedMediumPath];
}

@end
