//
//  DLSDirectoryServiceObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSDirectoryServiceObject.h"
#import "DLSTimetableObject.h"


@implementation DLSLocationObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"lng", @"lat"]];
    }];
}

@end


@implementation DLSDirectoryServiceObject
@synthesize openingTimesArray = _openingTimesArray;

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"id", @"name", @"address1", @"address2",@"town", @"country", @"postcode", @"website", @"telephone", @"distance"]];
        [mapping mapPropertiesFromDictionary:@{
                                               @"org_id": @"organisationId",
                                               @"category_id": @"categoryId",
                                               @"additional_properties.handles_minor_ailments": @"isHandleMinorAilments",
                                               @"opening_times_text": @"openingTimesText",
                                               @"description": @"serviceDescription"
                                               }];
        [mapping hasMany:[DLSTimetableObject class] forKeyPath:@"opening_times" forProperty:@"openingTimesArray"];
        [mapping hasOne:[DLSLocationObject class] forKeyPath:@"location" forProperty:@"location"];
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

- (void)setOpeningTimesArray:(NSArray<DLSTimetableObject> *)openingTimesArray
{
    _openingTimesArray = openingTimesArray;
    RLMArray *openingTimes = [[RLMArray alloc] initWithObjectClassName:[DLSTimetableObject className]];
    [openingTimesArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [openingTimes addObject:obj];
    }];
    self.openingTimes = (RLMArray<DLSTimetableObject> *)openingTimes;
}

- (NSArray<DLSTimetableObject> *)openingTimesArray
{
    return _openingTimesArray;
}

@end
