//
//  DLSContactObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>


@interface DLSContactObject : RLMObject <EKMappingProtocol>

@property NSString *organisationId;
@property NSString *patientName;
@property NSString *email;
@property NSString *contactNumber;
@property NSString *message;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSContactObject>
RLM_ARRAY_TYPE(DLSContactObject);
