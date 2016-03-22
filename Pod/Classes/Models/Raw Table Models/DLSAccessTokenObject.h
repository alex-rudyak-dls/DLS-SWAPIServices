//
//  DLSAccessTokenObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSUserProfileObject;

@interface DLSAccessTokenObject : RLMObject <EKMappingProtocol>

@property NSString *accessToken;
@property NSString *tokenType;
@property (nullable) NSString *idToken;
@property NSDate *expirationDate;
@property NSString *refreshToken;
@property NSString *scope;

@end

RLM_ARRAY_TYPE(DLSAccessTokenObject);

NS_ASSUME_NONNULL_END
