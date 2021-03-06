//
//  DLSAuthenticationServiceConfiguration.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAuthenticationServiceConfiguration.h"
#import "DLSAccessTokenObject.h"
#import "DLSUserProfileObject.h"
#import "DLSAuthenticationService.h"


@implementation DLSAuthenticationServiceConfiguration
@dynamic realmConfiguration;

- (RLMRealmConfiguration *)realmConfiguration
{
    DLSAuthCredentials *credentials = self.authService.credentials;
    RLMRealmConfiguration *realmConfiguration = [RLMRealmConfiguration defaultConfiguration];
    NSString *const filename = [NSString stringWithFormat:@"%@_instance.realm", credentials.username.lowercaseString];
    realmConfiguration.path = DLSUserDirectoryWithFilename(filename);
    realmConfiguration.objectClasses = @[ [DLSAccessTokenObject class], [DLSUserProfileObject class] ];
    return realmConfiguration;
}

@end
