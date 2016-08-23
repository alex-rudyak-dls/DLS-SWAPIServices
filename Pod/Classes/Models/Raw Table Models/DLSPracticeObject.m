//
//  DLSPracticeObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticeObject.h"


@implementation DLSPracticeObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name", @"address1", @"address2", @"town", @"country", @"county", @"postcode", @"website", @"area"]];
        [mapping mapPropertiesFromDictionary:@{
                                               @"handle": @"handleId",
                                               @"phone": @"telephone",
                                               @"registration_link": @"registrationLink",
                                               @"image_url": @"imageURL",
                                               @"opening_times": @"openingTimes",
                                               @"part_of_hub": @"partOfHub"
                                               }];
        [mapping mapKeyPath:@"id" toProperty:@"id" withValueBlock:^id(NSString *key, NSNumber *value) {
            return [value stringValue];
        } reverseBlock:^id(NSString *value) {
            return @([value integerValue]);
        }];
    }];
}

+ (NSString *)primaryKey
{
    return @"id";
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

+ (NSArray *)ignoredProperties
{
    return @[ @"openingTimesArray" ];
}

@end
