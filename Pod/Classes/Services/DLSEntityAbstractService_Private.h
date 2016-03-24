//
//  DLSEntityAbstractService_Private.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSEntityAbstractService.h"

@class BFTask;
@class BFExecutor;

NS_ASSUME_NONNULL_BEGIN

@interface DLSEntityAbstractService ()

@property (nonatomic, strong, readonly) BFExecutor *fetchExecutor;
@property (nonatomic, strong, readonly) BFExecutor *responseExecutor;

- (BFTask *)_failWithError:(NSError *)error;

- (BFTask *)_failWithError:(NSError *)error inMethod:(SEL)methodSelector;

- (BFTask *)_failWithException:(NSException *)exception;

- (BFTask *)_failWithException:(NSException *)exception inMethod:(SEL)methodSelector;

- (BFTask *)_failOfTask:(BFTask *)superTask;

- (BFTask *)_failOfTask:(BFTask *)superTask inMethod:(SEL)methodSelector;

- (BFTask *)_successWithResponse:(nullable id)response;

@end

NS_ASSUME_NONNULL_END
