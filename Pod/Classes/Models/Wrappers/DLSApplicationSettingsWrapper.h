//
//  DLSApplicationSettingsWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSApplicationSettingsObject.h"


@interface DLSApplicationSettingsWrapper : NSObject

@property (nonatomic, readonly) NSString *appName;

@property (nonatomic, strong) NSString *lastLoggedInUsername;

@property (nonatomic, strong) NSDate *lastStartupDate;

@property (nonatomic, assign) NSInteger contentVersion;

@property (nonatomic, assign, getter=isTermsOfUseAccepted) BOOL termsOfUseAccepted;

+ (instancetype)appSettingsWithObject:(DLSApplicationSettingsObject *)object;

- (instancetype)initWithObject:(DLSApplicationSettingsObject *)object;

- (DLSApplicationSettingsObject *)appObject;

@end
