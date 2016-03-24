//
//  DLSFeedbacksService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSFeedbacksService.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSFeedbackObject.h"
#import "DLSAuthenticationService.h"


@implementation DLSFeedbacksService

- (BFTask *)sendFeedback:(id)feedback
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const entity = [EKSerializer serializeObject:feedback withMapping:[DLSFeedbackObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport create:entity];
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:nil];
    }];
}

@end
