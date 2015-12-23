//
//  DLSFeedbacksService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"

@protocol DLSFeedbacksService <DLSEntityService>

- (PMKPromise *)sendFeedback:(id)feedback;

@end


@interface DLSFeedbacksService : DLSEntityAbstractService <DLSFeedbacksService>


@end
