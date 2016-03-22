//
//  DLSAccessTokenObject.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAccessTokenObject.h"

@implementation DLSAccessTokenObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"access_token": @"accessToken",
                                               @"refresh_token": @"refreshToken",
                                               @"id_token": @"idToken",
                                               @"token_type": @"tokenType",
                                               @"scope": @"scope"
                                               }];
        [mapping mapKeyPath:@"expires_in" toProperty:@"expirationDate" withValueBlock:^id(NSString *key, id value) {
            return [NSDate dateWithTimeIntervalSinceNow:[value floatValue]];
        }];
    }];
}

+ (NSString *)primaryKey
{
    return @"accessToken";
}

@end
