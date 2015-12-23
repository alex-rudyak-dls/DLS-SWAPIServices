//
//  DLSAppointmentRequestObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAppointmentObject.h"


@implementation DLSAppointmentObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"org_id": @"organisationId",
                                               @"id": @"id",
                                               @"phone": @"telephone",
                                               @"skype": @"skype",
                                               @"reason_for_appointment": @"reason",
                                               @"status": @"status",
                                               @"prefer_not_to_say": @"isPreferNotToSay",
                                               @"consultation_type": @"consultationType",
                                               @"is_request_for_self": @"isRequestForSelf",
                                               @"consent": @"isConsent"
                                               }];
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
