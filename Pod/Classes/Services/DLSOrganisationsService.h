//
//  DLSOrganisationsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSOrganisationWrapper;

@protocol DLSOrganisationsService <DLSEntityService>

- (BFTask<NSArray<DLSOrganisationWrapper *> *> *)fetchAll;

- (BFTask<DLSOrganisationWrapper *> *)fetchById:(id)identifier;

@end


@interface DLSOrganisationsService : DLSEntityAbstractService <DLSOrganisationsService>

@end

NS_ASSUME_NONNULL_END
