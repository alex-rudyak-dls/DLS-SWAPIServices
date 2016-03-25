//
//  ADEntityService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import "DLSEntityParser.h"
#import "DLSTransport.h"
#import "DLSServiceConfiguration.h"
#import "DLSConfigurable.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSAuthenticationService;

@protocol DLSEntityService <DLSConfigurable>

@required
@property (nonatomic, strong) id<DLSEntityParser> parser;
@property (nonatomic, strong) id<DLSTransport> transport;
@property (nonatomic, weak) DLSAuthenticationService *authService;

+ (instancetype)serviceWithConfiguration:(id<DLSServiceConfiguration>)configuration;

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration;

#pragma mark - Public methods

- (BFTask<NSArray *> *)fetchAll;

- (BFTask<id> *)fetchById:(id)identifier;

@end

NS_ASSUME_NONNULL_END
