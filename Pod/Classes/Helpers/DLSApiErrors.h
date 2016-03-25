//
//  DLSErrorsAPI.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSString *const DLSSouthWorcestershireErrorDomain;

typedef NS_ENUM(NSUInteger, DLSSouthWorcestershireErrorCode) {
    DLSSouthWorcestershireErrorCodeUnknown,
    DLSSouthWorcestershireErrorCodeAuthentication,
    DLSSouthWorcestershireErrorCodeSerialization,
    DLSSouthWorcestershireErrorCodePersistence
};


@interface NSError (DLSApiErrors)

+ (instancetype)errorWithDomainPostfix:(NSString *)postfix code:(DLSSouthWorcestershireErrorCode)code userInfo:(nullable NSDictionary<NSString *, id> *)dict;

+ (instancetype)errorUnauthorizedAccessWithInfo:(nullable NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
