//
//  DLSContentTextService.m
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import "DLSContentTextService.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSApiErrors.h"
#import "DLSApplicationSettingsWrapper.h"
#import "DLSApplicationContentObject.h"


@implementation DLSContentTextService

- (BFTask<DLSApplicationContentObject *> *)fetchLastVersionContent
{
    return [[[self.contentTransport fetchAllWithParams:nil] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSApplicationContentObject *const contentObject = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSApplicationContentObject objectMapping]];
        NSError *serializationError = nil;
        contentObject.content = [NSJSONSerialization dataWithJSONObject:task.result options:NSJSONWritingPrettyPrinted error:&serializationError];

        if (serializationError) {
            NSError *const domainError = [NSError errorWithDomainPostfix:@"response.serialization" code:DLSSouthWorcestershireErrorCodeSerialization userInfo:@{NSUnderlyingErrorKey: serializationError, NSLocalizedDescriptionKey: @"There are some problems with serialization response objects"}];
            return [self _failWithError:domainError inMethod:_cmd];
        }

        return contentObject;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask<NSNumber *> *)checkLatestVersion
{
    return [[[[self.versionTransport fetchAllWithParams:nil] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSApplicationContentObject *const contentObject = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSApplicationContentObject objectMapping]];

        return [BFTask taskForCompletionOfAllTasksWithResults:@[
                                                                [BFTask taskWithResult:contentObject],
                                                                [self.appSettingsService fetchCurrentAppSettings]
                                                                ]];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask<NSArray *> * _Nonnull task) {
        DLSApplicationContentObject *const contentObject = task.result.firstObject;
        DLSApplicationSettingsWrapper *const appSettings = task.result.lastObject;
        const BOOL hasNewVersion = contentObject.version > appSettings.contentVersion;
        return @(hasNewVersion);
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

@end
