//
//  DLSUserProfileObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSUserProfileObject.h"
#import "NSDateFormatter+DLSApiDates.h"


@implementation DLSUserProfileObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"firstname": @"firstName",
                                               @"lastname": @"lastName",
                                               @"sub": @"sub",
                                               @"email": @"email",
                                               @"phone": @"phone",
                                               @"gender": @"gender",
                                               @"gp": @"gp"
                                               }];
        [mapping mapKeyPath:@"dob" toProperty:@"dateOfBirth" withDateFormatter:[NSDateFormatter dls_shortDateFormatter]];
    }];
}

+ (NSString *)primaryKey
{
    return @"email";
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
