//
//  DLSContentTextService.m
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import "DLSContentTextService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSApplicationSettingsWrapper.h"
#import "DLSApplicationContentObject.h"


@implementation DLSContentTextService

- (PMKPromise *)fetchLastVersionContent
{
    return dispatch_promise_on(self.fetchQueue, ^{
        return [self.contentTransport fetchAllWithParams:nil];
    }).thenOn(self.fetchQueue, ^(NSDictionary *response) {
        DLSApplicationContentObject *const contentObject = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSApplicationContentObject objectMapping]];
        NSError *serializationError;
        contentObject.content = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&serializationError];

        if (serializationError) {
            @throw serializationError;
        }

        return [PMKPromise promiseWithValue:contentObject];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

- (PMKPromise *)checkLatestVersion
{
    return dispatch_promise_on(self.fetchQueue, ^{
        return [self.versionTransport fetchAllWithParams:nil];
    }).thenOn(self.fetchQueue, ^(NSDictionary *response) {
        DLSApplicationContentObject *const contentObject = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSApplicationContentObject objectMapping]];
        return [self.appSettingsService fetchCurrentAppSettings].thenOn(self.fetchQueue, ^(DLSApplicationSettingsWrapper *appSettings) {
            const BOOL hasNewVersion = contentObject.version > appSettings.contentVersion;
            return [PMKPromise promiseWithValue:@(hasNewVersion)];
        });
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

@end
