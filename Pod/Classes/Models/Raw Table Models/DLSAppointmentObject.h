//
//  DLSAppointmentRequestObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSAppointmentObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *organisationId;
@property (nullable) NSString *telephone;
@property (nullable) NSString *skype;
@property NSString *reason;
@property NSString *status;
@property NSNumber<RLMBool> *isPreferNotToSay;
@property NSString *consultationType;
@property NSNumber<RLMBool> *isRequestForSelf;
@property NSNumber<RLMBool> *isConsent;

@end

RLM_ARRAY_TYPE(DLSAppointmentRequestObject);

NS_ASSUME_NONNULL_END
