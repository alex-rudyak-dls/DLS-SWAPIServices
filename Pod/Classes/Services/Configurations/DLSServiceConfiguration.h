//
//  DLSServiceConfiguration.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMRealmConfiguration.h>
#import "DLSAppPaths.h"


@class DLSAuthenticationService;


@protocol DLSServiceConfiguration <NSObject>

@property (nonatomic, weak) DLSAuthenticationService *authService;

@property (nonatomic, copy, readonly) RLMRealmConfiguration *realmConfiguration;

@end
