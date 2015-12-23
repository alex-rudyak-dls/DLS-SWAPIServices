//
//  DLSApplicationSettingsWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApplicationSettingsWrapper.h"
#import "DLSModelsHelpers.h"


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
    return obj;
}

@end
