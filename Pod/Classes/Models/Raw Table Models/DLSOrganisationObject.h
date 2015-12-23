//
//  DLSOrganisationObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>


@interface DLSOrganisationObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSOrganisationObject>
RLM_ARRAY_TYPE(DLSOrganisationObject);
