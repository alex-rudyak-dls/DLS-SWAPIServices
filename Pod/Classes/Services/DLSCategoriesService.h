//
//  DLSCategoriesService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"

@protocol DLSCategoriesService <DLSEntityService>

@property (nonatomic, strong) NSString *organisationId;

@end


@interface DLSCategoriesService : DLSEntityAbstractService <DLSCategoriesService>

@property (nonatomic, strong) NSString *organisationId;

@end
