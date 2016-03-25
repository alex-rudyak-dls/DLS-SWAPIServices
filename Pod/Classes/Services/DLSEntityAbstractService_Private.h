//
//  DLSEntityAbstractService_Private.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import "DLSEntityAbstractService.h"

@class RLMRealm;
@class BFExecutor;

NS_ASSUME_NONNULL_BEGIN

@interface DLSEntityAbstractService ()

@property (nonatomic, strong, readonly) BFExecutor *fetchExecutor;
@property (nonatomic, strong, readonly) BFExecutor *responseExecutor;
@property (nonatomic, strong) dispatch_queue_t responseQueue;

@property (nonatomic, strong, readonly) id<DLSConfigurable> configurableWrapper;

- (BFContinuationBlock)_continueToCompleteBlock;

@end

NS_ASSUME_NONNULL_END
