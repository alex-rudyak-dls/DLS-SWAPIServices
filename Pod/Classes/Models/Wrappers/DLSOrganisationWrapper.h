//
//  DLSOrganisationWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSOrganisationObject;


@interface DLSOrganisationWrapper : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithOrganisation:(DLSOrganisationObject *)object;

+ (instancetype)organisationWithObject:(DLSOrganisationObject *)object;

@end
