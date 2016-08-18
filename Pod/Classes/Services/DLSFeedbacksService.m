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
#import "DLSAccessTokenWrapper.h"


OBJC_IMPORT NSString *DLSApiRequestSource;


@implementation DLSFeedbacksService

- (BFTask *)sendFeedback:(DLSFeedbackObject *)feedback
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const entity = [EKSerializer serializeObject:feedback withMapping:[DLSFeedbackObject objectMapping]];
        NSMutableDictionary *mutableEntity = [entity mutableCopy];
        mutableEntity[@"source"] = DLSApiRequestSource;

        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport create:entity];
    }];
}

@end
