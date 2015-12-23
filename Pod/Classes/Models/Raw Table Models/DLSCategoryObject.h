//
//  DLSCategoryObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>


@interface DLSCategoryObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *organisationId;
@property NSString *name;
@property NSString *slug;
@property NSString *desc;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSCategoryObject>
RLM_ARRAY_TYPE(DLSCategoryObject);
