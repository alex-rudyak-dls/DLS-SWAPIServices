//
//  DLSApplicationSettingsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApplicationSettingsService.h"
#import <Realm/Realm.h>
#import <ITDispatchManagement/ITDispatchManagement.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSApplicationSettingsObject.h"
#import "DLSApplicationSettingsWrapper.h"
#import "DLSAppPaths.h"


@implementation DLSApplicationSettingsService

- (BFTask *)fetchAll
{
    return [BFTask taskFromExecutor:self.fetchExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        RLMResults *const appSettings = [DLSApplicationSettingsObject allObjectsInRealm:realm];
        NSMutableArray *const appSettingsWrappers = [NSMutableArray arrayWithCapacity:appSettings.count];
        for (DLSApplicationSettingsObject *obj in appSettings) {
            [appSettingsWrappers addObject:[DLSApplicationSettingsWrapper appSettingsWithObject:obj]];
        }

        return [NSArray arrayWithArray:appSettingsWrappers];
    }];
}

- (BFTask *)fetchById:(id)identifier
{
    NSParameterAssert(identifier);

    return [BFTask taskFromExecutor:self.fetchExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        DLSApplicationSettingsObject *appSettings = [DLSApplicationSettingsObject objectInRealm:realm forPrimaryKey:identifier];
        if (!appSettings) {
            appSettings = [DLSApplicationSettingsObject new];
            appSettings.appId = identifier;
        }

        DLSApplicationSettingsWrapper *const appSettingsWrapper = [DLSApplicationSettingsWrapper appSettingsWithObject:appSettings];
        return appSettingsWrapper;
    }];
}

- (BFTask<DLSApplicationSettingsWrapper *> *)fetchCurrentAppSettings
{
    return [self fetchById:@"south-worcestershire-app"];
}

- (BFTask<DLSApplicationSettingsWrapper *> *)updateSettings:(DLSApplicationSettingsWrapper *)appSettings
{
    NSParameterAssert(appSettings);

    return [BFTask taskFromExecutor:self.fetchExecutor withBlock:^id _Nonnull{
        NSError *error;
        RLMRealm *const realm = [self realmInstance:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }

        [realm beginWriteTransaction];
        [realm addOrUpdateObject:[appSettings appObject]];
        [realm commitWriteTransaction];

        return appSettings;
    }];
}

@end
