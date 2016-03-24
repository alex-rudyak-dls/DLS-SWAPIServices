//
//  DLSPracticesService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticesService.h"
#import <Underscore.m/Underscore.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiConstants.h"
#import "DLSPracticeObject.h"
#import "DLSPracticeWrapper.h"
#import "DLSPracticeShortWrapper.h"
#import "DLSPracticeWrapperFactory.h"
#import "DLSAuthenticationService.h"


@implementation DLSPracticesService

- (BFTask *)fetchAll
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self fetchPracticesSorted:DLSPracticesListSortDefault];
    }];
}

- (BFTask *)fetchById:(id)identifier
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self fetchById:identifier withWrappersFactory:[DLSPracticeWrapperAbstractFactory new]];
    }];
}

- (BFTask<NSArray<DLSPracticeWrapper *> *> *)fetchPracticesSorted:(DLSPracticesListSort)sortKey
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self fetchPracticesSorted:sortKey withWrapperFactory:[DLSPracticeWrapperAbstractFactory new]];
    }];
}

- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)fetchPracticesPreviewSorted:(DLSPracticesListSort)sortKey
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self fetchPracticesSorted:sortKey withWrapperFactory:[DLSPracticeShortWrapperAbstractFactory new]];
    }];

}

- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)fetchAllPracticePreviews
{
    return [self fetchPracticesPreviewSorted:DLSPracticesListSortDefault];
}

#pragma mark - Helpers

- (BFTask *)fetchById:(id)identifier withWrappersFactory:(id<DLSPracticeWrapperFactory>)wrapperFactory
{
    return [[[BFTask taskFromExecutor:self.fetchExecutor withBlock:^id _Nonnull{
        [self updateMediumPaths];
        id<DLSTransport> const transport = self.entityTransport;
        [transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [transport fetchWithId:identifier];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSPracticeObject *practice = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSPracticeObject objectMapping]];
        return [wrapperFactory practiceWithObject:practice];
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask *)fetchPracticesSorted:(DLSPracticesListSort)sortKey withWrapperFactory:(id<DLSPracticeWrapperFactory>)wrapperFactory
{
    return [[[BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        [self updateMediumPaths];
        id<DLSTransport> const transport = self.listTransport;
        [transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [transport fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSPracticeObject *> * practices = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSPracticeObject objectMapping]];
        practices = [practices sortedArrayUsingDescriptors:@[[self nssortDescriptorForKey:sortKey]]];
        NSArray<DLSPracticeWrapper *> *const wrappers = [Underscore array](practices).map(^(DLSPracticeObject *practice) {
            return [wrapperFactory practiceWithObject:practice];
        }).unwrap;
        return wrappers;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask *)fetchPracticesPreviewWhichIsOnlyPartOfHub:(BOOL)isOnlyPartOfHub
{
    const DLSPracticesListSort sortAction = DLSPracticesListSortAlphabetically;
    if (!isOnlyPartOfHub) {
        return [self fetchPracticesPreviewSorted:sortAction];
    }

    return [[self fetchPracticesPreviewSorted:DLSPracticesListSortAlphabetically] continueWithExecutor:self.responseExecutor withSuccessBlock:^id _Nullable(BFTask<NSArray<DLSPracticeShortWrapper *> *> * _Nonnull task) {
        return [Underscore array](task.result).filter(^ BOOL(DLSPracticeShortWrapper *practice) {
            return practice.isPartOfHub;
        }).unwrap;
    }];
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
