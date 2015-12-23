//
//  DLSCategoryObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSCategoryObject.h"


@implementation DLSCategoryObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"id", @"slug", @"name"]];
        [mapping mapPropertiesFromDictionary:@{
                                               @"description": @"desc",
                                               @"org_id": @"organisationId"
                                               }];
    }];
}

+ (NSString *)primaryKey
{
    return @"id";
}

+ (NSArray *)indexedProperties
{
    return @[ @"id", @"slug" ];
}

@end
