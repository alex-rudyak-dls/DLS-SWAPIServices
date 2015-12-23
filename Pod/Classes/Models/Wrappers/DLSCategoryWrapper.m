//
//  DLSCategoryWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSCategoryWrapper.h"
#import "DLSCategoryObject.h"


@implementation DLSCategoryWrapper

+ (instancetype)categoryWithObject:(DLSCategoryObject *)object
{
    return [[self alloc] initWithCategory:object];
}

- (instancetype)initWithCategory:(DLSCategoryObject *)object
{
    self = [self init];
    if (self) {
        self.id = object.id;
        self.organisationId = object.organisationId;
        self.name = object.name;
        self.slug = object.slug;
        self.desc = object.desc;
    }
    return self;
}

@end
