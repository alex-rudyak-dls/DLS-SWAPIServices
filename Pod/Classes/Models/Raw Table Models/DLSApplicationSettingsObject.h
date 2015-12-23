//
//  DLSApplicationSettingsObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>


@interface DLSApplicationSettingsObject : RLMObject

@property NSString *appId;

@property BOOL isTermsOfUseAccepted;

@property NSString *lastUsername;

@property NSDate *lastStartup;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSApplicationSettingsObject>
RLM_ARRAY_TYPE(DLSApplicationSettingsObject);
