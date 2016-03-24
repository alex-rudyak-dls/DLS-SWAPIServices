//
//  DLSContactsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSContactsService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSAuthenticationService.h"
#import "DLSContactObject.h"


@implementation DLSContactsService

- (PMKPromise *)sendContactInformation:(id)contactInfo
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        NSDictionary *entity = [EKSerializer serializeObject:contactInfo withMapping:[DLSContactObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport create:entity];
    }).thenOn(self.responseQueue, ^(id response) {
        return [PMKPromise promiseWithValue:@YES];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

- (BFTask<DLSContactObject *> *)bft_sendContactInformation:(id)contactInfo
{
    return [[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const entity = [EKSerializer serializeObject:contactInfo withMapping:[DLSContactObject objectMapping]];
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
