//
//  DLSErrorsAPI.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApiErrors.h"

NSString *const DLSSouthWorcestershireErrorDomain = @"uk.co.south-worcestershire-api";


@implementation NSError (DLSApiErrors)

+ (instancetype)errorWithDomainPostfix:(NSString *)postfix code:(DLSSouthWorcestershireErrorCode)code userInfo:(nullable NSDictionary<NSString *,id> *)dict
{
    NSString *domain;
    if ([postfix length] > 0) {
        domain = [NSString stringWithFormat:@"%@.%@", DLSSouthWorcestershireErrorDomain, postfix];
    } else {
        domain = DLSSouthWorcestershireErrorDomain;
    }

    return [self errorWithDomain:domain code:code userInfo:dict];
}

+ (instancetype)errorUnauthorizedAccessWithInfo:(NSDictionary *)dict
{
    return [self errorWithDomainPostfix:@"unauth" code:DLSSouthWorcestershireErrorCodeAuthentication userInfo:dict];
}

@end
