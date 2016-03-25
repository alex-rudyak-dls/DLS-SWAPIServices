//
//  DLSEntityAbstractService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Realm/Realm.h>
#import <Bolts/Bolts.h>
#import "DLSPrivateHeader.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiErrors.h"
#import "DLSAuthenticationService.h"
#import "DLSRealmFactory.h"

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
        _configurableWrapper = [[DLSRealmFactory alloc] initWithConfiguration:configuration];
        _fetchQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        _responseQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
        _fetchExecutor = [BFExecutor executorWithDispatchQueue:_fetchQueue];
        _responseExecutor = [BFExecutor executorWithDispatchQueue:_responseQueue];
    }
    return self;
}

- (BFTask *)fetchAll
{
    //TODO: implement in siblings
    return [BFTask cancelledTask];
}

- (BFTask *)fetchById:(id)identifier
{
    //TODO: implement in siblings
    return [BFTask cancelledTask];
}

- (RLMRealm *)realmInstance:(NSError * _Nullable __autoreleasing *)error
{
    return [self.configurableWrapper realmInstance:error];
}

- (BFTask *)_failWithError:(NSError *)error
{
    DDLogDebug(@"[%@:General] %@", NSStringFromClass([self class]), [error localizedDescription]);
//    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithError:error];
//    }];
}

- (BFTask *)_failWithError:(NSError *)error inMethod:(SEL)methodSelector
{
    DDLogDebug(@"[%@:%@] %@", NSStringFromClass([self class]), NSStringFromSelector(methodSelector), [error localizedDescription]);
//    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithError:error];
//    }];
}

- (BFTask *)_failWithException:(NSException *)exception
{
    DDLogDebug(@"[%@:General] %@", NSStringFromClass([self class]), [exception debugDescription]);
//    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithException:exception];
//    }];
}

- (BFTask *)_failWithException:(NSException *)exception inMethod:(SEL)methodSelector
{
    DDLogDebug(@"[%@:%@] %@", NSStringFromClass([self class]), NSStringFromSelector(methodSelector), [exception debugDescription]);
//    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithException:exception];
//    }];
}

- (BFTask *)_failOfTask:(BFTask *)superTask inMethod:(nonnull SEL)methodSelector
{
    if (superTask.error) {
        return [self _failWithError:superTask.error inMethod:methodSelector];
    } else if (superTask.exception) {
        return [self _failWithException:superTask.exception inMethod:methodSelector];
    } else {
//        return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
            return [BFTask cancelledTask];
//        }];
    }
}

- (BFTask *)_failOfTask:(BFTask *)superTask
{
    if (superTask.error) {
        return [self _failWithError:superTask.error];
    } else if (superTask.exception) {
        return [self _failWithException:superTask.exception];
    } else {
//        return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
            return [BFTask cancelledTask];
//        }];
    }
}

- (BFTask *)_successWithResponse:(id)response
{
//    return [BFTask taskFromExecutor:self.responseExecutor withBlock:^id _Nonnull{
        return [BFTask taskWithResult:response];
//    }];
}

- (BFContinuationBlock)_continueToCompleteBlock
{
    return ^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    };
}

@end
