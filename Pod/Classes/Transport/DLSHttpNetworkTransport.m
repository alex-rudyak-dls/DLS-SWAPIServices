//
//  DLSAbstractTransport.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 11/30/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSHttpNetworkTransport.h"
#import <PromiseKit/PromiseKit.h>
#import <Bolts/Bolts.h>
#import "DLSPrivateHeader.h"
#import <ITDispatchManagement/ITDispatchManagement.h>
#import "NSString+DLSEntityParsing.h"
#import "DLSApiErrors.h"
#import "DLSApiConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSHttpNetworkTransport ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSOperationQueue *transportQueue;
@property (nonatomic, strong) BFExecutor *taskExecutor;

@end

@implementation DLSHttpNetworkTransport {
    NSString *_appendedPath;
}

- (instancetype)initWithManager:(AFHTTPSessionManager *)sessionManager pathFormat:(NSString *)pathFormat
{
    self = [super init];
    if (self) {
        _sessionManager = sessionManager;
        _pathFormat = pathFormat;
        _useRepeatRequest = YES;
        _repeatTimeout = 10;
        _repeatCount = 1;

        _transportQueue = [[NSOperationQueue alloc] init];
        _transportQueue.maxConcurrentOperationCount = 3;
        _transportQueue.name = @"uk.co.digitallifesciences.DLSHttpTransportQueue";
        _transportQueue.qualityOfService = NSQualityOfServiceUserInitiated;
        _queue = dispatch_queue_create("uk.co.digitallifesciences.DLSHttpTransportQueue_underlying", DISPATCH_QUEUE_CONCURRENT);
        _transportQueue.underlyingQueue = _queue;
    }
    return self;
}

- (void)dealloc
{
    [self.transportQueue cancelAllOperations];
}

- (instancetype)init
{
    self = [self initWithManager:[AFHTTPSessionManager manager] pathFormat:@""];
    return self;
}

#pragma mark - Accessors

- (void)setAuthorizationHeader:(nullable NSString *)authorizationHeader
{
    _authorizationHeader = authorizationHeader;

    [[self.sessionManager requestSerializer] setValue:_authorizationHeader forHTTPHeaderField:@"Authorization"];
}

- (void)setupBasicAuthWithUsername:(NSString *)username password:(NSString *)password
{
    NSData *data = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    [self setAuthorizationHeader:[NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]]];
}

#pragma mark - Requests

- (BFTask *)bft_fetchAllWithParams:(nullable NSDictionary<NSString *,id> *)parameters
{
    BFTaskCompletionSource *const taskSource = [BFTaskCompletionSource taskCompletionSource];
    NSString *const urlPath = [self urlPath];
    [self.transportQueue addOperationWithBlock:^{
        NSURLSessionTask *const dataTask = [self.sessionManager GET:urlPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"[HTTP:Transport:GET]: Success. %@(`%@`) - %@ ||| `%@`", urlPath, parameters, task.response, responseObject);
            [taskSource trySetResult:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DDLogDebug(@"[HTTP:Transport:GET]: Error. %@(`%@`) - %@", urlPath, parameters, [error localizedDescription]);
            [taskSource trySetError:error];
        }];

        if (taskSource.task.isCancelled) {
            [dataTask cancel];
        }
    }];
    return taskSource.task;
}

- (PMKPromise *)fetchAllWithParams:(NSDictionary *)parameters
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [[self bft_fetchAllWithParams:parameters] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (task.result) {
                resolve(task.result);
            } else {
                resolve(task.error);
            }
            return nil;
        }];
    }];
}

- (BFTask *)bft_fetchWithId:(id)entityIdentifier
{
    BFTaskCompletionSource *const taskSource = [BFTaskCompletionSource taskCompletionSource];
    NSString *const urlPath = [NSString stringWithFormat:@"%@/%@", [self urlPath], entityIdentifier];
    [self.transportQueue addOperationWithBlock:^{
        NSURLSessionTask *const dataTask = [self.sessionManager GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"[HTTP:Transport:GET]: Success. %@(`{id: %@}`) - %@ ||| `%@`", urlPath, entityIdentifier, task.response, responseObject);
            [taskSource trySetResult:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DDLogDebug(@"[HTTP:Transport:GET]: Error. %@(`{id: %@}`) - %@", urlPath, entityIdentifier, [error localizedDescription]);
            [taskSource trySetError:error];
        }];

        if (taskSource.task.isCancelled) {
            [dataTask cancel];
        }
    }];
    return taskSource.task;
}

- (PMKPromise *)fetchWithId:(id)entityIdentifier
{
    NSParameterAssert(entityIdentifier);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [[self bft_fetchWithId:entityIdentifier] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (task.result) {
                resolve(task.result);
            } else {
                resolve(task.error);
            }
            return nil;
        }];
    }];
}

- (BFTask *)bft_create:(NSDictionary *)entity
{
    NSParameterAssert(entity);

    BFTaskCompletionSource *const taskSource = [BFTaskCompletionSource taskCompletionSource];
    NSString *const urlPath = [self urlPath];
    [self.transportQueue addOperationWithBlock:^{
        NSMutableDictionary *mutableEntity = [NSMutableDictionary dictionaryWithDictionary:entity];
        mutableEntity[@"request_source"] = DLSApiRequestSource;
        [self.sessionManager POST:urlPath parameters:mutableEntity success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"[HTTP:Transport:CREATE]: Success. %@(`{%@}`) - %@ ||| `%@`", urlPath, entity, task.response, responseObject);
            [taskSource trySetResult:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DDLogDebug(@"[HTTP:Transport:CREATE]: Error. %@(`{%@}`) - %@", urlPath, entity, [error localizedDescription]);
            [taskSource trySetError:error];
        }];
    }];
    return taskSource.task;

}

- (PMKPromise *)create:(NSDictionary *)entity
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [[self bft_create:entity] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (task.result) {
                resolve(task.result);
            } else {
                resolve(task.error);
            }
            return nil;
        }];
    }];
}

- (BFTask *)bft_update:(NSDictionary *)entity id:(id)entityIdentifier
{
    NSParameterAssert(entity);
    NSParameterAssert(entityIdentifier);

    BFTaskCompletionSource *const taskSource = [BFTaskCompletionSource taskCompletionSource];
    NSString *const urlPath = [NSString stringWithFormat:[self urlPath], entityIdentifier];
    [self.transportQueue addOperationWithBlock:^{
        NSMutableDictionary *mutableEntity = [NSMutableDictionary dictionaryWithDictionary:entity];
        mutableEntity[@"request_source"] = DLSApiRequestSource;
        [self.sessionManager PUT:urlPath parameters:mutableEntity success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"[HTTP:Transport:UPDATE]: Success. %@(`{%@}`) - %@ ||| `%@`", urlPath, entity, task.response, responseObject);
            [taskSource trySetResult:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DDLogDebug(@"[HTTP:Transport:UPDATE]: Error. %@(`{%@}`) - %@", urlPath, entity, [error localizedDescription]);
            [taskSource trySetError:error];
        }];
    }];
    return taskSource.task;
}

- (PMKPromise *)update:(NSDictionary *)entity id:(id)entityIdentifier
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [[self bft_update:entity id:entityIdentifier] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (task.result) {
                resolve(task.result);
            } else {
                resolve(task.error);
            }
            return nil;
        }];
    }];
}

- (BFTask *)bft_patch:(NSDictionary *)entity id:(id)entityIdentifier
{
    NSParameterAssert(entity);
    NSParameterAssert(entityIdentifier);

    BFTaskCompletionSource *const taskSource = [BFTaskCompletionSource taskCompletionSource];
    //todo: fix for formatted urlPath
    NSString *const urlPath = [NSString stringWithFormat:[self urlPath], entityIdentifier];
    [self.transportQueue addOperationWithBlock:^{
        NSMutableDictionary *mutableEntity = [NSMutableDictionary dictionaryWithDictionary:entity];
        mutableEntity[@"request_source"] = DLSApiRequestSource;
        [self.sessionManager PATCH:urlPath parameters:mutableEntity success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"[HTTP:Transport:PATCH]: Success. %@(`{%@}`) - %@ ||| `%@`", urlPath, entity, task.response, responseObject);
            [taskSource trySetResult:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DDLogDebug(@"[HTTP:Transport:PATCH]: Error. %@(`{%@}`) - %@", urlPath, entity, [error localizedDescription]);
            [taskSource trySetError:error];
        }];
    }];
    return taskSource.task;
}

- (PMKPromise *)patch:(NSDictionary *)entity id:(id)entityIdentifier
{

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [[self bft_patch:entity id:entityIdentifier] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (task.result) {
                resolve(task.result);
            } else {
                resolve(task.error);
            }
            return nil;
        }];
    }];
}

- (BFTask *)bft_removeWithId:(id)entityIdentifier
{
    NSParameterAssert(entityIdentifier);
    NSString *const urlPath = [NSString stringWithFormat:[self urlPath], entityIdentifier];
    BFTaskCompletionSource *const taskSource = [BFTaskCompletionSource taskCompletionSource];
    [self.transportQueue addOperationWithBlock:^{
        [self.sessionManager DELETE:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            DDLogVerbose(@"[HTTP:Transport:DELETE]: Success. %@(`{id: %@}`) - %@ ||| `%@`", urlPath, entityIdentifier, task.response, responseObject);
            [taskSource trySetResult:responseObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            DDLogDebug(@"[HTTP:Transport:DELETE]: Error. %@(`{id: %@}`) - %@", urlPath, entityIdentifier, [error localizedDescription]);
            [taskSource trySetError:error];
        }];
    }];
    return taskSource.task;
}

- (PMKPromise *)removeWithId:(id)entityIdentifier
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [[self bft_removeWithId:entityIdentifier] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            if (task.result) {
                resolve(task.result);
            } else {
                resolve(task.error);
            }
            return nil;
        }];
    }];
}

- (void)updateMediumPathIdentifiers:(NSDictionary *)updatedIdentifiers
{
    if (!updatedIdentifiers.count) {
        return;
    }

    NSMutableDictionary *mediumIds = ([self mediumPathIdentifiers] ?: [NSDictionary dictionary]).mutableCopy;
    [updatedIdentifiers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        mediumIds[key] = obj;
    }];
    [self setMediumPathIdentifiers:[NSDictionary dictionaryWithDictionary:mediumIds]];
}

- (void)appendPathForOneRequest:(NSString *)temporalPath
{
    _appendedPath = temporalPath;
}

#pragma mark - Internals

- (NSString *)urlPath
{
    __block NSString *filledPath = [self.pathFormat copy];
    if (_appendedPath.length) {
        filledPath = [filledPath stringByAppendingPathComponent:_appendedPath];
        _appendedPath = nil;
    }
    if ([self.pathFormat dls_containsEntities]) {
        [self.mediumPathIdentifiers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            NSString *entityKey = [NSString stringWithFormat:@"{%@}", key];
            filledPath = [filledPath stringByReplacingOccurrencesOfString:entityKey withString:obj];
        }];
        if ([filledPath dls_containsEntities]) {
            NSError *const error = [NSError errorWithDomainPostfix:@"transport.path.formatting" code:DLSSouthWorcestershireErrorCodeUnknown userInfo:@{ NSLocalizedDescriptionKey : [NSString stringWithFormat:@"One or more medium ids were missed in transport path %@.", filledPath] }];
            @throw error;
        }
    }

    return [[self.sessionManager.baseURL absoluteString] stringByAppendingPathComponent:filledPath];
}

@end

NS_ASSUME_NONNULL_END
