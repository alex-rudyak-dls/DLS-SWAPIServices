//
//  DLSFeedbackObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>


@interface DLSFeedbackObject : RLMObject <EKMappingProtocol>

@property NSString *organisationId;
@property NSString *feedbackOnService;
@property NSNumber<RLMInt> *recommendationLikelihood;
@property NSString *howYouFeel;
@property NSString *tellUsMore;
@property NSNumber<RLMBool> *havePermissionToPublish;
@property NSString *practiceOrOrganisation;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSFeedbackObject>
RLM_ARRAY_TYPE(DLSFeedbackObject);
