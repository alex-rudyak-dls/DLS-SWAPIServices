//
//  DLSAuthenticationServiceConfiguration.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSServiceConfiguration.h"


@interface DLSAuthenticationServiceConfiguration : NSObject <DLSServiceConfiguration>

@property (nonatomic, weak) DLSAuthenticationService *authService;

@end
