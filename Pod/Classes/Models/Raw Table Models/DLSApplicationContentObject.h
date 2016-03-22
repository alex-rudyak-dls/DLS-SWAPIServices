//
//  DLSApplicationContentObject.h
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSApplicationContentObject : RLMObject <EKMappingProtocol>

@property NSData *content;
@property NSInteger version;

@property (readonly) NSDictionary *contentDictionary;

@end

RLM_ARRAY_TYPE(DLSApplicationContentObject)

NS_ASSUME_NONNULL_END
