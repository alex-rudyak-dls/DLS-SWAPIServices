//
//  DLSApplicationContentObject.h
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>


@interface DLSApplicationContentObject : RLMObject <EKMappingProtocol>

@property NSData *content;
@property NSInteger version;

@property (readonly) NSDictionary *contentDictionary;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<DLSApplicationContentObject>
RLM_ARRAY_TYPE(DLSApplicationContentObject)
