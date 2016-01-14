//
//  DLSServiceLayer.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSAuthenticationService.h"
#import "DLSEntityService.h"
#import "DLSApplicationSettingsService.h"
#import "DLSUserProfileService.h"
#import "DLSServicesDirectoryService.h"
#import "DLSAppointmentsService.h"
#import "DLSCategoriesService.h"
#import "DLSOrganisationsService.h"
#import "DLSPracticesService.h"
#import "DLSFeedbacksService.h"
#import "DLSContactsService.h"
#import "DLSContentTextService.h"


@interface DLSServiceLayer : NSObject

@property (nonatomic, strong) DLSAuthenticationService *authService;

@property (nonatomic, strong) id<DLSApplicationSettingsService> appSettingsService;
@property (nonatomic, strong) id<DLSUserProfileService> userProfileService;
@property (nonatomic, strong) id<DLSServicesDirectoryService> directoryServicesService;
@property (nonatomic, strong) id<DLSAppointmentsService> appointmentsService;
@property (nonatomic, strong) id<DLSCategoriesService> categoriesService;
@property (nonatomic, strong) id<DLSOrganisationsService> organisationsService;
@property (nonatomic, strong) id<DLSPracticesService> practicesService;
@property (nonatomic, strong) id<DLSFeedbacksService> feedbacksService;
@property (nonatomic, strong) id<DLSContactsService> contactsService;
@property (nonatomic, strong) id<DLSContentTextService> contentTextService;

- (PMKPromise *)initialize;

@end
