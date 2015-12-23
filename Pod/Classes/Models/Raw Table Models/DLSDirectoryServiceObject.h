//
//  DLSDirectoryServiceObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>
#import "DLSTimetableObject.h"


@interface DLSLocationObject : RLMObject <EKMappingProtocol>

@property float lng;
@property float lat;

@end

RLM_ARRAY_TYPE(DLSLocationObject);


@interface DLSDirectoryServiceObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *organisationId;
@property NSString *categoryId;
@property NSString *name;
@property NSString *address1;
@property NSString *address2;
@property NSString *town;
@property NSString *country;
@property NSString *postcode;
@property DLSLocationObject *location;
@property NSString *website;
@property NSString *telephone;
@property RLMArray<DLSTimetableObject *><DLSTimetableObject> *openingTimes;
@property float distance;

@property NSArray<DLSTimetableObject> *openingTimesArray;

@property NSNumber<RLMBool> *isHandleMinorAilments;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSDirectoryServiceObject>
RLM_ARRAY_TYPE(DLSDirectoryServiceObject);
