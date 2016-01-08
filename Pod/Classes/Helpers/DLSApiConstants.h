//
//  DLSConstants.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXTERN NSString *const DLSApiRedirectUrlString;
OBJC_EXTERN NSString *const DLSApiRequestSource;

OBJC_EXTERN NSString *const DLSRestorePasswordUrlString;
OBJC_EXTERN NSString *const DLSRegisterUrlString;


// Authentication routes
OBJC_EXTERN NSString *const DLSApiAuthTokenRoute;
OBJC_EXTERN NSString *const DLSApiAuthAuthorizeRoute;
OBJC_EXTERN NSString *const DLSApiAuthLogoutRoute;


// API calls
OBJC_EXTERN NSString *const DLSApiUserInfoRoute;

OBJC_EXTERN NSString *const DLSApiServicesDirectoryRoute;
OBJC_EXTERN NSString *const DLSApiAppointmentsRoute;
OBJC_EXTERN NSString *const DLSApiCategoriesRoute;
OBJC_EXTERN NSString *const DLSApiOrganisationsRoute;
OBJC_EXTERN NSString *const DLSApiPracticesRoute;
OBJC_EXTERN NSString *const DLSApiPracticesInOrganisationRoute;
OBJC_EXTERN NSString *const DLSApiFeedbackRoute;
OBJC_EXTERN NSString *const DLSApiContactRoute;


#pragma mark - Path ids

OBJC_EXTERN NSString *const DLSPathOrganisationEntityId;
