//
//  DLSTimetableObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSTimetableObject.h"


@implementation DLSDayTime

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"open", @"close"]];
        [mapping mapPropertiesFromDictionary:@{@"holiday": @"isHoliday"}];
    }];
}

@end


@implementation DLSTimetableObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"monday"];
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"tuesday"];
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"wednesday"];
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"thursday"];
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"friday"];
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"saturday"];
        [mapping hasOne:[DLSDayTime class] forKeyPath:@"sunday"];
    }];
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
