//
//  DLSAccessTokenObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

@class DLSUserProfileObject;


@interface DLSAccessTokenObject : RLMObject <EKMappingProtocol>

@property NSString *accessToken;
@property NSString *tokenType;
@property NSString *idToken;
@property NSDate *expirationDate;
@property NSString *refreshToken;
@property NSString *scope;

@end

RLM_ARRAY_TYPE(DLSAccessTokenObject);
