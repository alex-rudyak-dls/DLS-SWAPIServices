//
//  DLSUserProfileObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSUserProfileObject : RLMObject <EKMappingProtocol>

@property NSString *firstName;
@property NSString *lastName;
@property NSString *email;
@property (nullable) NSString *phone;
@property (nullable) NSString *skype;
@property NSString *gender;
@property (nullable) NSString *gp;
@property NSString *sub;
@property NSDate *dateOfBirth;

@end

RLM_ARRAY_TYPE(DLSUserProfileObject);

NS_ASSUME_NONNULL_END
