//
//  DLSAccessToken.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAccessTokenWrapper.h"
#import <NSDate-Escort/NSDate+Escort.h>


@implementation DLSAccessTokenWrapper

+ (instancetype)tokenWithObject:(DLSAccessTokenObject *)object
{
    return [[self alloc] initWithToken:object];
}

- (instancetype)initWithToken:(DLSAccessTokenObject *)object
{
    self = [self init];
    if (self) {
        self.accessToken = object.accessToken;
        self.refreshToken = object.refreshToken;
        self.idToken = object.idToken;
        self.expirationDate = object.expirationDate;
        self.tokenType = object.tokenType;
        self.scope = object.scope;
    }
    return self;
}

- (BOOL)isValid
{
    return self.accessToken.length > 0 && [self.expirationDate isInFuture];
}

- (NSString *)authenticationHeaderValue
{
    return [NSString stringWithFormat:@"%@ %@", self.tokenType.capitalizedString, self.accessToken];
}

@end
