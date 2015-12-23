//
//  DLSAccessToken.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSAccessTokenObject.h"


@interface DLSAccessTokenWrapper : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenType;
@property (nonatomic, strong) NSString *idToken;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *scope;

- (instancetype)initWithToken:(DLSAccessTokenObject *)object;

+ (instancetype)tokenWithObject:(DLSAccessTokenObject *)object;

- (BOOL)isValid;

- (NSString *)authenticationHeaderValue;

@end
