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

NS_ASSUME_NONNULL_BEGIN

@interface DLSPracticeObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *handleId;
@property NSString *name;
@property (nullable) NSString *address1;
@property (nullable) NSString *address2;
@property (nullable) NSString *town;
@property (nullable) NSString *country;
@property (nullable) NSString *area;
@property NSString *postcode;
@property (nullable) NSString *website;
@property (nullable) NSString *telephone;
@property (nullable) NSString *openingTimes;
@property (nullable) NSString *registrationLink;
@property (nullable) NSString *imageURL;
@property BOOL partOfHub;

@end

RLM_ARRAY_TYPE(DLSPracticeObject);

NS_ASSUME_NONNULL_END
