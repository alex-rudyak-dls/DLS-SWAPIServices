//
//  DLSUserProfileService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSUserProfileWrapper;

@protocol DLSUserProfileService <DLSEntityService>

- (BFTask<NSArray<DLSUserProfileWrapper *> *> *)fetchAll;

- (BFTask<DLSUserProfileWrapper *> *)fetchById:(id)identifier;

- (BFTask<DLSUserProfileWrapper *> *)fetchUserProfile;

- (BFTask<DLSUserProfileWrapper *> *)updateUserProfile:(DLSUserProfileWrapper *)userProfile;

@end


@interface DLSUserProfileService : DLSEntityAbstractService <DLSUserProfileService>

@end

NS_ASSUME_NONNULL_END
