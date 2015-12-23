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
    realmConfiguration.path = DLSUserDirectoryWithFilename(@"app_default.realm");
    realmConfiguration.objectClasses = @[ [DLSApplicationSettingsObject class] ];
    return realmConfiguration;
}

@end
