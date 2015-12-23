//
//  DLSPracticeObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticeObject.h"


@implementation DLSPracticeObject
@synthesize openingTimesArray = _openingTimesArray;

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"name", @"address1", @"address2", @"town", @"country", @"postcode", @"website", @"area"]];
        [mapping mapPropertiesFromDictionary:@{
                                               @"phone": @"telephone",
                                               @"registration_link": @"registrationLink",
                                               @"image_url": @"imageURL"
                                               }];
        [mapping mapKeyPath:@"id" toProperty:@"id" withValueBlock:^id(NSString *key, NSNumber *value) {
            return [value stringValue];
        } reverseBlock:^id(NSString *value) {
            return @([value integerValue]);
        }];
        [mapping hasMany:[DLSTimetableObject class] forKeyPath:@"opening_times" forProperty:@"openingTimesArray"];
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
