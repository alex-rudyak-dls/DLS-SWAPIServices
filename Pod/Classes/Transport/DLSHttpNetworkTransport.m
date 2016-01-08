//
//  DLSAbstractTransport.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 11/30/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSHttpNetworkTransport.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSPrivateHeader.h"
#import <ITDispatchManagement/ITDispatchManagement.h>
#import "NSString+DLSEntityParsing.h"
#import "DLSApiErrors.h"
#import "DLSApiConstants.h"


@implementation DLSHttpNetworkTransport {
    NSString *_appendedPath;
}

static dispatch_queue_t TransportQueue;

- (instancetype)initWithManager:(AFHTTPSessionManager *)sessionManager pathFormat:(NSString *)pathFormat
{
    self = [super init];
    if (self) {
        _sessionManager = sessionManager;
        _pathFormat = pathFormat;
        _useRepeatRequest = YES;
        _repeatTimeout = 10;
        _repeatCount = 1;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            TransportQueue = dispatch_queue_create("uk.co.digitallifesciences.DLSHttpTransportQueue", DISPATCH_QUEUE_CONCURRENT);
        });
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithManager:[AFHTTPSessionManager manager] pathFormat:@""];
    return self;
}

- (void)setAuthorizationHeader:(NSString *)authorizationHeader
{
    _authorizationHeader = authorizationHeader;

    [[self.sessionManager requestSerializer] setValue:_authorizationHeader forHTTPHeaderField:@"Authorization"];
}

- (PMKPromise *)fetchAllWithParams:(NSDictionary *)parameters
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(TransportQueue, ^{
            NSString *const urlPath = [self urlPath];
            [self.sessionManager GET:urlPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                DDLogVerbose(@"[HTTP:Transport:GET]: Success. %@(`%@`) - %@ ||| `%@`", urlPath, parameters, task.response, responseObject);
                resolve(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DDLogDebug(@"[HTTP:Transport:GET]: Error. %@(`%@`) - %@", urlPath, parameters, [error localizedDescription]);
                resolve(error);
            }];
        });
    }];
}

- (PMKPromise *)fetchWithId:(id)entityIdentifier
{
    NSParameterAssert(entityIdentifier);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(TransportQueue, ^{
            //todo: fix for formatted urlPath
            NSString *const urlPath = [NSString stringWithFormat:@"%@/%@", [self urlPath], entityIdentifier];
            [self.sessionManager GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                DDLogVerbose(@"[HTTP:Transport:GET]: Success. %@(`{id: %@}`) - %@ ||| `%@`", urlPath, entityIdentifier, task.response, responseObject);
                resolve(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DDLogDebug(@"[HTTP:Transport:GET]: Error. %@(`{id: %@}`) - %@", urlPath, entityIdentifier, [error localizedDescription]);
                resolve(error);
            }];
        });
    }];
}

- (PMKPromise *)create:(NSDictionary *)entity
{
    NSParameterAssert(entity);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(TransportQueue, ^{
            NSString *const urlPath = [self urlPath];
            NSMutableDictionary *mutableEntity = [NSMutableDictionary dictionaryWithDictionary:entity];
            mutableEntity[@"request_source"] = DLSApiRequestSource;
            [self.sessionManager POST:urlPath parameters:mutableEntity success:^(NSURLSessionDataTask *task, id responseObject) {
                DDLogVerbose(@"[HTTP:Transport:CREATE]: Success. %@(`{%@}`) - %@ ||| `%@`", urlPath, entity, task.response, responseObject);
                resolve(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DDLogDebug(@"[HTTP:Transport:CREATE]: Error. %@(`{%@}`) - %@", urlPath, entity, [error localizedDescription]);
                resolve(error);
            }];
        });
    }];
}

- (PMKPromise *)update:(NSDictionary *)entity id:(id)entityIdentifier
{
    NSParameterAssert(entity);
    NSParameterAssert(entityIdentifier);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(TransportQueue, ^{
            //todo: fix for formatted urlPath
            NSString *const urlPath = [NSString stringWithFormat:[self urlPath], entityIdentifier];
            NSMutableDictionary *mutableEntity = [NSMutableDictionary dictionaryWithDictionary:entity];
            mutableEntity[@"request_source"] = DLSApiRequestSource;
            [self.sessionManager PUT:urlPath parameters:mutableEntity success:^(NSURLSessionDataTask *task, id responseObject) {
                DDLogVerbose(@"[HTTP:Transport:UPDATE]: Success. %@(`{%@}`) - %@ ||| `%@`", urlPath, entity, task.response, responseObject);
                resolve(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DDLogDebug(@"[HTTP:Transport:UPDATE]: Error. %@(`{%@}`) - %@", urlPath, entity, [error localizedDescription]);
                resolve(error);
            }];
        });
    }];
}

- (PMKPromise *)patch:(NSDictionary *)entity id:(id)entityIdentifier
{
    NSParameterAssert(entity);
    NSParameterAssert(entityIdentifier);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(TransportQueue, ^{
            //todo: fix for formatted urlPath
            NSString *const urlPath = [NSString stringWithFormat:[self urlPath], entityIdentifier];
            NSMutableDictionary *mutableEntity = [NSMutableDictionary dictionaryWithDictionary:entity];
            mutableEntity[@"request_source"] = DLSApiRequestSource;
            [self.sessionManager PATCH:urlPath parameters:mutableEntity success:^(NSURLSessionDataTask *task, id responseObject) {
                DDLogVerbose(@"[HTTP:Transport:PATCH]: Success. %@(`{%@}`) - %@ ||| `%@`", urlPath, entity, task.response, responseObject);
                resolve(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DDLogDebug(@"[HTTP:Transport:PATCH]: Error. %@(`{%@}`) - %@", urlPath, entity, [error localizedDescription]);
                resolve(error);
            }];
        });
    }];
}

- (PMKPromise *)removeWithId:(id)entityIdentifier
{
    NSParameterAssert(entityIdentifier);
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(TransportQueue, ^{
            NSString *const urlPath = [NSString stringWithFormat:[self urlPath], entityIdentifier];
            [self.sessionManager DELETE:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                DDLogVerbose(@"[HTTP:Transport:DELETE]: Success. %@(`{id: %@}`) - %@ ||| `%@`", urlPath, entityIdentifier, task.response, responseObject);
                resolve(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DDLogDebug(@"[HTTP:Transport:DELETE]: Error. %@(`{id: %@}`) - %@", urlPath, entityIdentifier, [error localizedDescription]);
                resolve(error);
            }];
        });
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
