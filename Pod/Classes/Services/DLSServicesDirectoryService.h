//
//  DLSServicesDirectoryService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import "DLSEntityAbstractService.h"
#import "DLSLocationWrapper.h"
#import "DLSServicesDirectoryConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSDirectoryServiceWrapper;

@protocol DLSServicesDirectoryService <DLSEntityService>

@property (nonatomic, strong) DLSLocationWrapper *currentLocation;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *organisationId;

- (BFTask<NSArray<DLSDirectoryServiceWrapper *> *> *)bft_fetchAll;

- (BFTask<DLSDirectoryServiceWrapper *> *)bft_fetchById:(id)identifier;

- (BFTask<NSArray<DLSDirectoryServiceWrapper *> *> *)bft_fetchAllServicesForLocation:(DLSLocationWrapper *)location filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey;

- (BFTask<NSArray<DLSDirectoryServiceWrapper *> *> *)bft_fetchAllServicesFilteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey;

- (BFTask<NSArray<DLSDirectoryServiceWrapper *> *> *)bft_fetchAllServicesWithPostcode:(NSString *)postcode filteredBy:(DLSServiceDirectoryFiltration)filterKey sortedBy:(DLSServiceDirectorySort)sortKey;

@end


@interface DLSServicesDirectoryService : DLSEntityAbstractService <DLSServicesDirectoryService>

@property (nonatomic, strong) DLSLocationWrapper *currentLocation;

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *organisationId;

@end

NS_ASSUME_NONNULL_END
