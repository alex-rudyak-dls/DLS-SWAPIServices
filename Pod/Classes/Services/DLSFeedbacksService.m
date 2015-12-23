//
//  DLSFeedbacksService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSFeedbacksService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSFeedbackObject.h"
#import "DLSAuthenticationService.h"


@implementation DLSFeedbacksService

- (PMKPromise *)sendFeedback:(id)feedback
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        NSDictionary *entity = [EKSerializer serializeObject:feedback withMapping:[DLSFeedbackObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport create:entity];
    }).thenOn(self.fetchQueue, ^(id response) {
        return [PMKPromise promiseWithValue:@YES];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

@end
