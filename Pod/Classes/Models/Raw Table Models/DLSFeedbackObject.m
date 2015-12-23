//
//  DLSFeedbackObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSFeedbackObject.h"


@implementation DLSFeedbackObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"org_id": @"organisationId",
                                               @"feedback_on_service": @"feedbackOnService",
                                               @"recommendation_likelihood": @"recommendationLikelihood",
                                               @"how_you_feel": @"howYouFeel",
                                               @"tell_us_more": @"tellUsMore",
                                               @"permission_to_publish": @"havePermissionToPublish",
                                               @"gp_practice_or_organisation": @"practiceOrOrganisation"
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
