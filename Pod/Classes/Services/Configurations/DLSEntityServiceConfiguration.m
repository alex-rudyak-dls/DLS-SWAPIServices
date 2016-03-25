//
//  DLSEntityServiceConfiguration.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityServiceConfiguration.h"
#import "DLSAuthenticationService.h"
#import "DLSDirectoryServiceObject.h"
#import "DLSTimetableObject.h"
#import "DLSAccessTokenObject.h"
#import "DLSUserProfileObject.h"
#import "DLSCategoryObject.h"
#import "DLSPracticeObject.h"
#import "DLSAuthCredentials.h"


@implementation DLSEntityServiceConfiguration
@dynamic realmConfiguration;

- (RLMRealmConfiguration *)realmConfiguration
{
    DLSAuthCredentials *credentials = self.authService.credentials;
    RLMRealmConfiguration *realmConfiguration = [RLMRealmConfiguration defaultConfiguration];
    NSString *const filename = [NSString stringWithFormat:@"%@_instance.realm", credentials.username.lowercaseString];
    realmConfiguration.path = DLSUserDirectoryWithFilename(filename);
    realmConfiguration.objectClasses = @[
        [DLSLocationObject class],
        [DLSDirectoryServiceObject class],
        [DLSDayTime class],
        [DLSTimetableObject class],
        [DLSAccessTokenObject class],
        [DLSUserProfileObject class],
        [DLSCategoryObject class],
        [DLSPracticeObject class]
    ];
    return realmConfiguration;
}

@end
