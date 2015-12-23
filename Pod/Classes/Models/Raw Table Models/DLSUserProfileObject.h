//
//  DLSUserProfileObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>
#import "DLSAccessTokenObject.h"


@interface DLSUserProfileObject : RLMObject <EKMappingProtocol>

@property NSString *firstName;
@property NSString *lastName;
@property NSString *email;
@property NSString *phone;
@property NSString *gender;
@property NSString *gp;
@property NSString *sub;
@property NSDate *dateOfBirth;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSUserProfileObject>
RLM_ARRAY_TYPE(DLSUserProfileObject);
