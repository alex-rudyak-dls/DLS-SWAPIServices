//
//  DLSServicesDirectoryService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import "DLSLocationWrapper.h"
#import "DLSServicesDirectoryConstants.h"

@protocol DLSServicesDirectoryService <DLSEntityService>

@property (nonatomic, strong) DLSLocationWrapper *currentLocation;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *organisationId;

- (PMKPromise *)fetchAllServicesForLocation:(DLSLocationWrapper *)location filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey;
- (PMKPromise *)fetchAllServicesFilteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey;
- (PMKPromise *)fetchAllServicesWithPostcode:(NSString *)postcode filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey;

@end


@interface DLSServicesDirectoryService : DLSEntityAbstractService <DLSServicesDirectoryService>

@property (nonatomic, strong) DLSLocationWrapper *currentLocation;

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *organisationId;

@end
