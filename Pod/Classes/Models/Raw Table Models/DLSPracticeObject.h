//
//  DLSPracticeObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>
#import "DLSTimetableObject.h"


@interface DLSPracticeObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *name;
@property NSString *address1;
@property NSString *address2;
@property NSString *town;
@property NSString *country;
@property NSString *area;
@property NSString *postcode;
@property NSString *website;
@property NSString *telephone;
@property NSString *openingTimes;
@property NSString *registrationLink;
@property NSString *imageURL;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSPracticeObject>
RLM_ARRAY_TYPE(DLSPracticeObject);
