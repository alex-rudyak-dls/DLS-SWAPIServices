//
//  DLSConstants.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSString *const DLSApiRequestSource;


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
OBJC_EXTERN NSString *const DLSApiContentTextVersionRoute;
OBJC_EXTERN NSString *const DLSApiContentTextRoute;


#pragma mark - Path ids

OBJC_EXTERN NSString *const DLSPathOrganisationEntityId;

NS_ASSUME_NONNULL_END
