//
//  DLSConstants.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/7/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSApiConstants.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const DLSApiRequestSource = @"iOS";

NSString *const DLSApiAuthTokenRoute = @"/token";
NSString *const DLSApiAuthAuthorizeRoute = @"/authorize";
NSString *const DLSApiAuthLogoutRoute = @"/logout";

NSString *const DLSApiUserInfoRoute = @"/userinfo";

NSString *const DLSApiServicesDirectoryRoute = @"/orgs/{ORG_ID}/directory_services";
NSString *const DLSApiAppointmentsRoute = @"/appointment_requests";
NSString *const DLSApiCategoriesRoute = @"/orgs/{ORG_ID}/directory_services/categories";
NSString *const DLSApiOrganisationsRoute = @"/orgs";
NSString *const DLSApiPracticesRoute = @"/practices";
NSString *const DLSApiPracticesInOrganisationRoute = @"orgs/{ORG_ID}/practices";
NSString *const DLSApiFeedbackRoute = @"/feedback";
NSString *const DLSApiContactRoute = @"/contact";
NSString *const DLSApiContentTextVersionRoute = @"/apps/ios-version.json";
NSString *const DLSApiContentTextRoute = @"/apps/ios.json";

#pragma mark -

NSString *const DLSPathOrganisationEntityId = @"ORG_ID";

NS_ASSUME_NONNULL_END
