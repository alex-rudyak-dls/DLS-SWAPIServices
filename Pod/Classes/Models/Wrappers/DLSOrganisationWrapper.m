//
//  DLSOrganisationWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSOrganisationWrapper.h"
#import "DLSOrganisationObject.h"


@implementation DLSOrganisationWrapper

+ (instancetype)organisationWithObject:(DLSOrganisationObject *)object
{
    return [[self alloc] initWithOrganisation:object];
}

- (instancetype)initWithOrganisation:(DLSOrganisationObject *)object
{
    self = [self init];
    if (self) {
        self.id = object.id;
        self.name = object.name;
    }
    return self;
}

@end
