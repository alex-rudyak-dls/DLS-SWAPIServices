//
//  DLSServicesDirectoryService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSServicesDirectoryService.h"
#import "DLSEntityAbstractService_Private.h"
#import <PromiseKit/PromiseKit.h>
#import <Underscore.m/Underscore.h>
#import "DLSAppPaths.h"
#import "DLSDirectoryServiceObject.h"
#import "DLSDirectoryServiceWrapper.h"
#import "DLSApiErrors.h"
#import "DLSApiConstants.h"
#import "DLSAuthenticationService.h"


@implementation DLSServicesDirectoryService

- (PMKPromise *)fetchAll
{
    return nil;
}

- (BFTask *)bft_fetchAll
{
    return [self bft_fetchAllServicesForLocation:self.currentLocation filteredBy:DLSServiceDirectoryFiltrationDefault sortedBy:DLSServiceDirectorySortDefault];
}

- (PMKPromise *)fetchById:(id)identifier
{
    return nil;
}

- (BFTask *)bft_fetchById:(id)identifier
{
    return [[[[[self bft_validateParameters] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self.authService checkToken];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self updateTransportPaths];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchWithId:identifier];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSDirectoryServiceObject *const directoryService = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSDirectoryServiceObject objectMapping]];
        return [DLSDirectoryServiceWrapper directoryServiceWithObject:directoryService];
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (PMKPromise *)fetchAllServicesForLocation:(DLSLocationWrapper *)location filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return nil;
}

- (BFTask *)bft_fetchAllServicesForLocation:(DLSLocationWrapper *)location filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return [[[[[self bft_validateParameters] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self.authService bft_checkToken];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self updateTransportPaths];
        if (filterKey & DLSServiceDirectoryFiltrationOpenNow) {
            [self.transport appendPathForOneRequest:@"open"];
        }
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchAllWithParams:@{
                                                    @"cat_id": self.categoryId,
                                                    @"minor_ailments": @((BOOL)(filterKey & DLSServiceDirectoryFiltrationMinorAilment)),
                                                    @"lat": @(location.latitude),
                                                    @"lng": @(location.longitude)
                                                    }];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSDirectoryServiceObject *> *const directoryServices = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSDirectoryServiceObject objectMapping]];
        return [Underscore array](directoryServices).map(^(DLSDirectoryServiceObject *directoryService) {
            return [DLSDirectoryServiceWrapper directoryServiceWithObject:directoryService];
        }).filter([self filterBlockForKey:filterKey])
        .sort([self sortBlockForKey:sortKey])
        .unwrap;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (PMKPromise *)fetchAllServicesFilteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return [self fetchAllServicesForLocation:self.currentLocation filteredBy:filterKey sortedBy:sortKey];
}

- (BFTask *)bft_fetchAllServicesFilteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return [self bft_fetchAllServicesForLocation:self.currentLocation filteredBy:filterKey sortedBy:sortKey];
}

- (PMKPromise *)fetchAllServicesWithPostcode:(NSString *)postcode filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return nil;
}

- (BFTask *)bft_fetchAllServicesWithPostcode:(NSString *)postcode filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return [[[[[self bft_validateParameters] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        return [self.authService bft_checkToken];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self updateTransportPaths];
        if (filterKey & DLSServiceDirectoryFiltrationOpenNow) {
            [self.transport appendPathForOneRequest:@"open"];
        }
        return [self.transport bft_fetchAllWithParams:@{
                                                    @"cat_id": self.categoryId,
                                                    @"minor_ailments": @((BOOL)(filterKey & DLSServiceDirectoryFiltrationMinorAilment)),
                                                    @"postcode": postcode
                                                    }];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSDirectoryServiceObject *> *const directoryServices = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSDirectoryServiceObject objectMapping]];
        return [Underscore array](directoryServices).map(^(DLSDirectoryServiceObject *directoryService) {
            return [DLSDirectoryServiceWrapper directoryServiceWithObject:directoryService];
        }).filter([self filterBlockForKey:filterKey])
        .sort([self sortBlockForKey:sortKey])
        .unwrap;
    }] continueWithExecutor:self.responseExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

#pragma mark -

- (UnderscoreSortBlock)sortBlockForKey:(DLSServiceDirectorySort)sortKey
{
    return ^NSComparisonResult(DLSDirectoryServiceWrapper *obj1, DLSDirectoryServiceWrapper *obj2) {
        if (sortKey == DLSServiceDirectorySortAlphabetical) {
            return [obj1.name compare:obj2.name];
        } else if (sortKey == DLSServiceDirectorySortDistance) {
            return [@(obj1.distance) compare:@(obj2.distance)];
        }
        return NSOrderedAscending;
    };
}

- (UnderscoreTestBlock)filterBlockForKey:(DLSServiceDirectoryFiltration)filterKey
{
    return ^BOOL(DLSDirectoryServiceWrapper *directoryService) {
        if (filterKey & DLSServiceDirectoryFiltrationOpenNow) {

        }
        return YES;
    };
}

- (NSPredicate *)filterPredicateForKey:(DLSServiceDirectoryFiltration)filtrationKey
{
    NSPredicate *filterPredicate;
    switch (filtrationKey) {
        case DLSServiceDirectoryFiltrationOpenNow: {
            filterPredicate = [NSPredicate predicateWithValue:NO];
            break;
        }
        case DLSServiceDirectoryFiltrationMinorAilment: {
            filterPredicate = [NSPredicate predicateWithFormat:@"isHandleMinorAilments != nil AND isHandleMinorAilments = @YES"];
            break;
        }
        case DLSServiceDirectoryFiltrationNone:
        default: {
            filterPredicate = [NSPredicate predicateWithValue:YES];
            break;
        }
    }

    NSPredicate *const categoryPredicate = [NSPredicate predicateWithFormat:@"categoryId = %@", self.categoryId];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[ categoryPredicate, filterPredicate ]];
}

- (RLMSortDescriptor *)sortDescriptorForKey:(DLSServiceDirectorySort)sortKey
{
    switch (sortKey) {
        case DLSServiceDirectorySortDistance: {
            return [RLMSortDescriptor sortDescriptorWithProperty:@"distance" ascending:YES];
            break;
        }
        case DLSServiceDirectorySortAlphabetical:
        default: {
            return [RLMSortDescriptor sortDescriptorWithProperty:@"name" ascending:YES];
            break;
        }
    }
    return nil;
}

#pragma mark -

- (PMKPromise *)validateParameters
{
    if (self.organisationId.length == 0 || self.categoryId.length == 0) {
        NSError *const error = [NSError errorWithDomainPostfix:@"services_directory.missed_property" code:DLSSouthWorcestershireErrorCodeUnknown userInfo:@{ NSLocalizedDescriptionKey : @"Missed one of key property to fetch services. First set it up to valid values" }];
        return [PMKPromise promiseWithValue:error];
    }

    return nil;
}

- (BFTask *)bft_validateParameters
{
    if (self.organisationId.length == 0 || self.categoryId.length == 0) {
        NSError *const error = [NSError errorWithDomainPostfix:@"services_directory.missed_property" code:DLSSouthWorcestershireErrorCodeUnknown userInfo:@{ NSLocalizedDescriptionKey : @"Missed one of key property to fetch services. First set it up to valid values" }];
        return [BFTask taskWithError:error];
    }

    return [BFTask taskWithResult:nil];
}

- (void)updateTransportPaths
{
    NSParameterAssert(self.organisationId);

    [self.transport updateMediumPathIdentifiers:@{
        DLSPathOrganisationEntityId : self.organisationId
    }];
}

@end
