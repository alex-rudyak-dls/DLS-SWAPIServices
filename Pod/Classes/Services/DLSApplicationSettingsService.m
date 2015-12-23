//
//  DLSApplicationSettingsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApplicationSettingsService.h"
#import "DLSEntityAbstractService_Private.h"
#import <PromiseKit/PromiseKit.h>
#import <Realm/Realm.h>
#import <ITDispatchManagement/ITDispatchManagement.h>
#import "DLSApplicationSettingsObject.h"
#import "DLSApplicationSettingsWrapper.h"
#import "DLSAppPaths.h"


@interface DLSApplicationSettingsService ()

@end


@implementation DLSApplicationSettingsService

- (PMKPromise *)fetchAll
{
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(self.fetchQueue, ^{
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:resolve];
                return;
            }

            RLMResults *appSettings = [DLSApplicationSettingsObject allObjectsInRealm:realm];
            NSMutableArray *appSettingsWrappers = [NSMutableArray arrayWithCapacity:appSettings.count];
            for (DLSApplicationSettingsObject *obj in appSettings) {
                [appSettingsWrappers addObject:[DLSApplicationSettingsWrapper appSettingsWithObject:obj]];
            }

            [self _successWithResponse:[NSArray arrayWithArray:appSettingsWrappers] completion:resolve];
        });
    }];
}

- (PMKPromise *)fetchById:(id)identifier
{
    NSParameterAssert(identifier != nil);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(self.fetchQueue, ^{
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:resolve];
                return;
            }

            DLSApplicationSettingsObject *appSettings = [DLSApplicationSettingsObject objectInRealm:realm forPrimaryKey:identifier];
            if (!appSettings) {
                appSettings = [DLSApplicationSettingsObject new];
                appSettings.appId = identifier;
            }
            DLSApplicationSettingsWrapper *appSettingsWrapper = [DLSApplicationSettingsWrapper appSettingsWithObject:appSettings];

            [self _successWithResponse:appSettingsWrapper completion:resolve];
        });
    }];
}

- (PMKPromise *)fetchCurrentAppSettings
{
    return [self fetchById:@"south-worcestershire-app"];
}

- (PMKPromise *)updateSettings:(DLSApplicationSettingsWrapper *)appSettings
{
    NSParameterAssert(appSettings);

    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        it_dispatch_on_queue(self.fetchQueue, ^{
            NSError *error;
            RLMRealm *realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&error];
            if (error) {
                [self _failWithError:error inMethod:_cmd completion:resolve];
                return;
            }

            [realm beginWriteTransaction];
            [realm addOrUpdateObject:[appSettings appObject]];
            [realm commitWriteTransaction];

            [self _successWithResponse:appSettings completion:resolve];
        });
    }];
}

@end
