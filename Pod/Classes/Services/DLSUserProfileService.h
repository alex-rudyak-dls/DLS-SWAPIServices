//
//  DLSUserProfileService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"

@class DLSUserProfileWrapper;

@protocol DLSUserProfileService <DLSEntityService>

- (PMKPromise *)fetchUserProfile;

- (PMKPromise *)updateUserProfile:(DLSUserProfileWrapper *)userProfile;

@end


@interface DLSUserProfileService : DLSEntityAbstractService <DLSUserProfileService>

@end
