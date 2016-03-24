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
        _fetchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        _responseQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        _fetchExecutor = [BFExecutor executorWithDispatchQueue:_fetchQueue];
        _responseExecutor = [BFExecutor executorWithDispatchQueue:_responseQueue];
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

- (BFTask *)bft_fetchAll
{
    return [BFTask cancelledTask];
}

- (BFTask *)bft_fetchById:(id)identifier
{
    return [BFTask cancelledTask];
}

- (BFTask *)_failWithError:(NSError *)error
{
    DDLogDebug(@"[%@:General] %@", NSStringFromClass([self class]), [error localizedDescription]);
    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithError:error];
    }];
}

- (BFTask *)_failWithError:(NSError *)error inMethod:(SEL)methodSelector
{
    DDLogDebug(@"[%@:%@] %@", NSStringFromClass([self class]), NSStringFromSelector(methodSelector), [error localizedDescription]);
    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithError:error];
    }];
}

- (BFTask *)_failWithException:(NSException *)exception
{
    DDLogDebug(@"[%@:General] %@", NSStringFromClass([self class]), [exception debugDescription]);
    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithException:exception];
    }];
}

- (BFTask *)_failWithException:(NSException *)exception inMethod:(SEL)methodSelector
{
    DDLogDebug(@"[%@:%@] %@", NSStringFromClass([self class]), NSStringFromSelector(methodSelector), [exception debugDescription]);
    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithException:exception];
    }];
}

- (BFTask *)_failOfTask:(BFTask *)superTask inMethod:(nonnull SEL)methodSelector
{
    if (superTask.error) {
        return [self _failWithError:superTask.error inMethod:methodSelector];
    } else if (superTask.exception) {
        return [self _failWithException:superTask.exception inMethod:methodSelector];
    } else {
        return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
            return [BFTask cancelledTask];
        }];
    }
}

- (BFTask *)_failOfTask:(BFTask *)superTask
{
    if (superTask.error) {
        return [self _failWithError:superTask.error];
    } else if (superTask.exception) {
        return [self _failWithException:superTask.exception];
    } else {
        return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
            return [BFTask cancelledTask];
        }];
    }
}

- (BFTask *)_successWithResponse:(id)response
{
    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithResult:response];
    }];
}

@end
