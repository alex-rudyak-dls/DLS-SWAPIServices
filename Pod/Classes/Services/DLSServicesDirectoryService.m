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
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        return [self fetchAllServicesForLocation:self.currentLocation filteredBy:DLSServiceDirectoryFiltrationDefault sortedBy:DLSServiceDirectorySortDefault];
    });
}

- (PMKPromise *)fetchById:(id)identifier
{
    PMKPromise *errorValidation = [self validateParameters];
    if (errorValidation) {
        return errorValidation;
    }

    return [super fetchById:identifier].thenOn(self.fetchQueue, ^() {
        [self updateTransportPaths];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchWithId:identifier];
    }).thenOn(self.fetchQueue, ^(NSDictionary *response) {
        DLSDirectoryServiceObject *directoryService = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSDirectoryServiceObject objectMapping]];
        return [DLSDirectoryServiceWrapper directoryServiceWithObject:directoryService];
    }).thenOn(self.responseQueue, ^(DLSDirectoryServiceWrapper *wrapper) {
        [self _successWithResponse:wrapper completion:nil];
        return [PMKPromise promiseWithValue:wrapper];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
}

- (PMKPromise *)fetchAllServicesForLocation:(DLSLocationWrapper *)location filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    PMKPromise *errorValidation = [self validateParameters];
    if (errorValidation) {
        return errorValidation;
    }

    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        [self updateTransportPaths];
        if (filterKey & DLSServiceDirectoryFiltrationOpenNow) {
            [self.transport appendPathForOneRequest:@"open"];
        }
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchAllWithParams:@{
                                                    @"cat_id": self.categoryId,
                                                    @"minor_ailments": @((BOOL)(filterKey & DLSServiceDirectoryFiltrationMinorAilment)),
                                                    @"lat": @(location.latitude),
                                                    @"long": @(location.longitude)
                                                    }];

    }).thenOn(self.fetchQueue, ^(NSArray *response) {
        NSArray<DLSDirectoryServiceObject *> *directoryServices = [EKMapper arrayOfObjectsFromExternalRepresentation:response withMapping:[DLSDirectoryServiceObject objectMapping]];
        return [Underscore array](directoryServices).map(^(DLSDirectoryServiceObject *directoryService) {
            return [DLSDirectoryServiceWrapper directoryServiceWithObject:directoryService];
        }).filter([self filterBlockForKey:filterKey])
        .sort([self sortBlockForKey:sortKey])
        .unwrap;
    }).thenOn(self.responseQueue, ^(NSArray *directoryServices) {
        [self _successWithResponse:directoryServices completion:nil];
        return [PMKPromise promiseWithValue:directoryServices];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
}

- (PMKPromise *)fetchAllServicesFilteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    return [self fetchAllServicesForLocation:self.currentLocation filteredBy:filterKey sortedBy:sortKey];
}

- (PMKPromise *)fetchAllServicesWithPostcode:(NSString *)postcode filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey
{
    PMKPromise *errorValidation = [self validateParameters];
    if (errorValidation) {
        return errorValidation;
    }

    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        [self updateTransportPaths];
        if (filterKey & DLSServiceDirectoryFiltrationOpenNow) {
            [self.transport appendPathForOneRequest:@"open"];
        }
        return [self.transport fetchAllWithParams:@{
                                                    @"cat_id": self.categoryId,
                                                    @"minor_ailments": @((BOOL)(filterKey & DLSServiceDirectoryFiltrationMinorAilment)),
                                                    @"postcode": postcode
                                                    }];

    }).thenOn(self.fetchQueue, ^(NSArray *response) {
        NSArray<DLSDirectoryServiceObject *> *directoryServices = [EKMapper arrayOfObjectsFromExternalRepresentation:response withMapping:[DLSDirectoryServiceObject objectMapping]];
        return [Underscore array](directoryServices).map(^(DLSDirectoryServiceObject *directoryService) {
            return [DLSDirectoryServiceWrapper directoryServiceWithObject:directoryService];
        }).filter([self filterBlockForKey:filterKey])
        .sort([self sortBlockForKey:sortKey])
        .unwrap;
    }).thenOn(self.responseQueue, ^(NSArray *directoryServices) {
        [self _successWithResponse:directoryServices completion:nil];
        return [PMKPromise promiseWithValue:directoryServices];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
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

- (void)updateTransportPaths
{
    NSParameterAssert(self.organisationId);
    [self.transport updateMediumPathIdentifiers:@{
        DLSPathOrganisationEntityId : self.organisationId
    }];
}

@end
