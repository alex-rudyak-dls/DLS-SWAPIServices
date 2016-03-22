//
//  DLSApplicationSettingsObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSApplicationSettingsObject : RLMObject

@property NSString *appId;

@property BOOL isTermsOfUseAccepted;

@property (nullable) NSString *lastUsername;

@property (nullable) NSDate *lastStartup;

@property NSInteger contentVersion;

@end

RLM_ARRAY_TYPE(DLSApplicationSettingsObject);

NS_ASSUME_NONNULL_END
