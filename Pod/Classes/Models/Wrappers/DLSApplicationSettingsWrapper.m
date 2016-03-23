//
//  DLSApplicationSettingsWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApplicationSettingsWrapper.h"


@implementation DLSApplicationSettingsWrapper

+ (instancetype)appSettingsWithObject:(DLSApplicationSettingsObject *)object
{
    DLSApplicationSettingsWrapper *wrapper = [[self alloc] initWithObject:object];
    return wrapper;
}

- (instancetype)initWithObject:(DLSApplicationSettingsObject *)object
{
    self = [self init];
    if (self) {
        _appName = object.appId;
        [self setTermsOfUseAccepted:object.isTermsOfUseAccepted];
        [self setLastStartupDate:object.lastStartup];
        [self setLastLoggedInUsername:object.lastUsername];
        [self setContentVersion:object.contentVersion];
    }
    return self;
}

- (DLSApplicationSettingsObject *)appObject
{
    DLSApplicationSettingsObject *obj = [DLSApplicationSettingsObject new];
    obj.appId = self.appName;
    obj.isTermsOfUseAccepted = self.isTermsOfUseAccepted;
    obj.lastStartup = self.lastStartupDate;
    obj.lastUsername = self.lastLoggedInUsername;
    obj.contentVersion = self.contentVersion;
    return obj;
}

@end
