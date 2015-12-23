//
//  NSDateFormatter+DLSApiDates.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "NSDateFormatter+DLSApiDates.h"


@implementation NSDateFormatter (DLSApiDates)

+ (NSDateFormatter *)dls_shortDateFormatter
{
    static NSDateFormatter *shortFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shortFormatter = [NSDateFormatter new];
        [shortFormatter setDateFormat:@"dd-MM-yyyy"];
    });
    return shortFormatter;
}

@end
