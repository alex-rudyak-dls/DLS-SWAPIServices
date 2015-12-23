//
//  DLSAnonymousAppointmentObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/10/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAnonymousAppointmentObject.h"
#import "NSDateFormatter+DLSApiDates.h"


@implementation DLSAnonymousAppointmentObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromMappingObject:[super objectMapping]];
        [mapping mapPropertiesFromDictionary:@{
                                               @"firstname": @"firstName",
                                               @"lastname": @"lastName",
                                               @"email": @"email",
                                               @"gender": @"gender",
                                               @"gp": @"gp"
                                               }];
        [mapping mapKeyPath:@"dob" toProperty:@"dateOfBirth" withDateFormatter:[NSDateFormatter dls_shortDateFormatter]];
    }];
}

@end
