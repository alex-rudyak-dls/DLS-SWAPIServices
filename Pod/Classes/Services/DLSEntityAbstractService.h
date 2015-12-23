//
//  DLSEntityAbstractService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMRealmConfiguration.h>
#import "DLSEntityService.h"
#import <ITDispatchManagement/ITDispatchManagement.h>


@interface DLSEntityAbstractService : NSObject <DLSEntityService>

@property (nonatomic, readonly) id<DLSServiceConfiguration> serviceConfiguration;

@property (nonatomic, strong) id<DLSEntityParser> parser;
@property (nonatomic, strong) id<DLSTransport> transport;
@property (nonatomic, weak) DLSAuthenticationService *authService;

/**
 *  Describes on which queue will be requesting data from local or remote sources.
 *  Default: background queue with default priority
 */
@property (nonatomic, strong) dispatch_queue_t fetchQueue;

/**
 *  Describes on which queue response will be returned to user.
 *  Default: main queue
 */
@property (nonatomic, strong) dispatch_queue_t responseQueue;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration NS_DESIGNATED_INITIALIZER;

- (PMKPromise *)fetchAll NS_REQUIRES_SUPER;

- (PMKPromise *)fetchById:(id)identifier NS_REQUIRES_SUPER;

@end
