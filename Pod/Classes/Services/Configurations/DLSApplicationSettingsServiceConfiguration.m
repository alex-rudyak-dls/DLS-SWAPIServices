//
//  DLSApplicationSettingsServiceConfiguration.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApplicationSettingsServiceConfiguration.h"
#import "DLSApplicationSettingsObject.h"


@implementation DLSApplicationSettingsServiceConfiguration

- (RLMRealmConfiguration *)realmConfiguration
{
    RLMRealmConfiguration *realmConfiguration = [RLMRealmConfiguration defaultConfiguration];
    realmConfiguration.fileURL = [NSURL fileURLWithPath:DLSUserDirectoryWithFilename(@"app_default.realm")];
    realmConfiguration.objectClasses = @[ [DLSApplicationSettingsObject class],
                                          [DLSAccessTokenObject class],
                                          [DLSUserProfileObject class],
                                          [DLSLocationObject class],
                                          [DLSDirectoryServiceObject class],
                                          [DLSDayTime class],
                                          [DLSTimetableObject class],
                                          [DLSAccessTokenObject class],
                                          [DLSUserProfileObject class],
                                          [DLSCategoryObject class],
                                          [DLSPracticeObject class]];
    realmConfiguration.schemaVersion = DLSRealmSchemeVersion;
    realmConfiguration.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {

        }
    };
    return realmConfiguration;
}

@end
