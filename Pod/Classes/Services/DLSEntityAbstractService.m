//
//  DLSEntityAbstractService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSPrivateHeader.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSAuthenticationService.h"



@implementation DLSEntityAbstractService

+ (instancetype)serviceWithConfiguration:(id<DLSServiceConfiguration>)configuration
{
    return [[self alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration
{
    self = [super init];
    if (self) {
        _serviceConfiguration = configuration;
        self.fetchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.responseQueue = dispatch_get_main_queue();
    }
    return self;
}

- (PMKPromise *)fetchAll
{
    return [self.authService checkToken].thenOn(self.fetchQueue, ^() {
        return [PMKPromise promiseWithValue:@[]];
    });
}

- (PMKPromise *)fetchById:(id)identifier
{
    return [self.authService checkToken].thenOn(self.fetchQueue, ^() {
        return [PMKPromise promiseWithValue:nil];
    });
}

- (void)_failWithError:(NSError *)error completion:(void (^)(NSError *))completion
{
    it_dispatch_on_queue(self.responseQueue, ^{
        DDLogDebug(@"[%@:General] %@", NSStringFromClass([self class]), [error localizedDescription]);
        if (completion) {
            completion(error);
        }
    });
}

- (void)_failWithError:(NSError *)error inMethod:(SEL)methodSelector completion:(void (^)(NSError *))completion
{
    it_dispatch_on_queue(self.responseQueue, ^{
        DDLogDebug(@"[%@:%@] %@", NSStringFromClass([self class]), NSStringFromSelector(methodSelector), [error localizedDescription]);
        if (completion) {
            completion(error);
        }
    });
}

- (void)_successWithResponse:(id)response completion:(void (^)(id response))completion
{
    it_dispatch_on_queue(self.responseQueue, ^{
        if (completion) {
            completion(response);
        }
    });
}

@end
