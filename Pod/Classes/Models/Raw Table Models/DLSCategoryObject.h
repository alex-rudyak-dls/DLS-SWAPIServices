//
//  DLSCategoryObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Realm/Realm.h>
#import <EasyMapping/EasyMapping.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSCategoryObject : RLMObject <EKMappingProtocol>

@property NSString *id;
@property NSString *organisationId;
@property NSString *name;
@property NSString *slug;
@property NSString *desc;

@end

RLM_ARRAY_TYPE(DLSCategoryObject);

NS_ASSUME_NONNULL_END
