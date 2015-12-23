//
//  ADEntityService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSEntityParser.h"
#import "DLSTransport.h"
#import "DLSServiceConfiguration.h"


@class PMKPromise;
@class DLSAuthenticationService;


@protocol DLSEntityService <NSObject>

@required

@property (nonatomic, readonly) id<DLSServiceConfiguration> serviceConfiguration;

@property (nonatomic, strong) id<DLSEntityParser> parser;
@property (nonatomic, strong) id<DLSTransport> transport;
@property (nonatomic, weak) DLSAuthenticationService *authService;

- (PMKPromise *)fetchAll;
- (PMKPromise *)fetchById:(id)identifier;

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration;

+ (instancetype)serviceWithConfiguration:(id<DLSServiceConfiguration>)configuration;

@end
