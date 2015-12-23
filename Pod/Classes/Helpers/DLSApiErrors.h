//
//  DLSErrorsAPI.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN NSString *const DLSSouthWorcestershireErrorDomain;

typedef NS_ENUM(NSUInteger, DLSSouthWorcestershireErrorCode) {
    DLSSouthWorcestershireErrorCodeUnknown,
    DLSSouthWorcestershireErrorCodeAuthentication
};


@interface NSError (DLSApiErrors)

+ (instancetype)errorWithDomainPostfix:(NSString *)postfix code:(DLSSouthWorcestershireErrorCode)code userInfo:(NSDictionary *)dict;

+ (instancetype)errorUnauthorizedAccessWithInfo:(NSDictionary *)dict;

@end
