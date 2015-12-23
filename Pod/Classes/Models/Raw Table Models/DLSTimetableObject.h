//
//  DLSTimetableObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>


@interface DLSDayTime : RLMObject <EKMappingProtocol>

@property NSString *dayName;
@property NSString *open;
@property NSString *close;
@property BOOL isHoliday;

@end

RLM_ARRAY_TYPE(DLSDayTime);


@interface DLSTimetableObject : RLMObject <EKMappingProtocol>

@property DLSDayTime *monday;
@property DLSDayTime *tuesday;
@property DLSDayTime *wednesday;
@property DLSDayTime *thursday;
@property DLSDayTime *friday;
@property DLSDayTime *saturday;
@property DLSDayTime *sunday;

@end

RLM_ARRAY_TYPE(DLSTimetableObject);
