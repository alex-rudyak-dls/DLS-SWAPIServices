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

NS_ASSUME_NONNULL_BEGIN

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
@property (nullable) NSString *address1;
@property (nullable) NSString *address2;
@property (nullable) NSString *town;
@property (nullable) NSString *country;
@property (nullable) NSString *postcode;
@property DLSLocationObject *location;
@property (nullable) NSString *website;
@property (nullable) NSString *telephone;
@property RLMArray<DLSTimetableObject *><DLSTimetableObject> *openingTimes;
@property (nullable) NSString *openingTimesText;
@property (nullable) NSString *serviceDescription;
@property float distance;

@property NSArray<DLSTimetableObject> *openingTimesArray;

@property NSNumber<RLMBool> *isHandleMinorAilments;

@end

RLM_ARRAY_TYPE(DLSDirectoryServiceObject);

NS_ASSUME_NONNULL_END
