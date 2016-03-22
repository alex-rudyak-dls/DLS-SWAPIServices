//
//  DLSContactObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSContactObject : RLMObject <EKMappingProtocol>

@property NSString *organisationId;
@property NSString *patientName;
@property NSString *email;
@property NSString *contactNumber;
@property (nullable) NSString *message;

@end

RLM_ARRAY_TYPE(DLSContactObject);

NS_ASSUME_NONNULL_END
