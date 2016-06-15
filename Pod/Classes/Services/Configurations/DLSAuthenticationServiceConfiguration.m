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
#import "DLSAuthCredentials.h"


@implementation DLSAuthenticationServiceConfiguration
@dynamic realmConfiguration;

- (RLMRealmConfiguration *)realmConfiguration
{
    DLSAuthCredentials *credentials = self.authService.credentials;
    RLMRealmConfiguration *realmConfiguration = [RLMRealmConfiguration defaultConfiguration];
    NSString *const filename = [NSString stringWithFormat:@"%@_instance.realm", credentials.username.lowercaseString];
    realmConfiguration.fileURL = [NSURL fileURLWithPath:DLSUserDirectoryWithFilename(filename)];
    realmConfiguration.objectClasses = @[ [DLSAccessTokenObject class], [DLSUserProfileObject class] ];
    realmConfiguration.schemaVersion = DLSRealmSchemeVersion;
    realmConfiguration.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {

        }
    };
    return realmConfiguration;
}

@end
