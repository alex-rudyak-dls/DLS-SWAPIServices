//
//  DLSCategoriesService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSCategoryWrapper;

@protocol DLSCategoriesService <DLSEntityService>

@property (nonatomic, strong) NSString *organisationId;

- (BFTask<NSArray<DLSCategoryWrapper *> *> *)fetchAll;

@end


@interface DLSCategoriesService : DLSEntityAbstractService <DLSCategoriesService>

@property (nonatomic, strong) NSString *organisationId;

@end

NS_ASSUME_NONNULL_END
