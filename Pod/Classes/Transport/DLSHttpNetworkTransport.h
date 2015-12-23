//
//  DLSAbstractTransport.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 11/30/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSTransport.h"
#import <AFNetworking/AFNetworking.h>


@interface DLSHttpNetworkTransport : NSObject <DLSTransport>

@property (nonatomic, strong) NSString *authorizationHeader;
@property (nonatomic, strong) NSDictionary *mediumPathIdentifiers;

@property (nonatomic, readonly) AFHTTPSessionManager *sessionManager;
@property (nonatomic, readonly) NSString *pathFormat;

/**
 *  Timeout to repeat error request.
 *  Default: 10 seconds
 */
@property (nonatomic, assign) NSTimeInterval repeatTimeout;

/**
 *  Defines if transport should use repeatable requests.
 *  Default: YES
 */
@property (nonatomic, assign, getter=isUseRepeatRequest) BOOL useRepeatRequest;

/**
 *  Defines number of repeats.
 *  Default: 1
 */
@property (nonatomic, assign) NSInteger repeatCount;

- (instancetype)initWithManager:(AFHTTPSessionManager *)sessionManager pathFormat:(NSString *)pathFormat NS_DESIGNATED_INITIALIZER;

@end
