//
//  DLSFeedbacksService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSFeedbackObject;

@protocol DLSFeedbacksService <DLSEntityService>

- (BFTask<NSArray<DLSFeedbackObject *> *> *)fetchAll;

- (BFTask<DLSFeedbackObject *> *)fetchById:(id)identifier;

- (BFTask *)sendFeedback:(id)feedback;

@end


@interface DLSFeedbacksService : DLSEntityAbstractService <DLSFeedbacksService>

@end

NS_ASSUME_NONNULL_END
