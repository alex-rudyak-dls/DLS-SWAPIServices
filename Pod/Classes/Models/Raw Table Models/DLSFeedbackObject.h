//
//  DLSFeedbackObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSFeedbackObject : RLMObject <EKMappingProtocol>

@property NSString *organisationId;
@property NSString *feedbackOnService;
@property NSNumber<RLMInt> *recommendationLikelihood;
@property NSString *howYouFeel;
@property (nullable) NSString *tellUsMore;
@property NSNumber<RLMBool> *havePermissionToPublish;
@property NSString *practiceOrOrganisation;

@end

RLM_ARRAY_TYPE(DLSFeedbackObject);

NS_ASSUME_NONNULL_END
