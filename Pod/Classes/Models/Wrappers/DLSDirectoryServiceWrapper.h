//
//  DLSDirectoryServiceWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSLocationWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSDirectoryServiceObject;
@class DLSTimetableWrapper;

@interface DLSDirectoryServiceWrapper : NSObject

@property (nonatomic, readonly) NSString *directoryId;
@property (nonatomic, readonly) NSString *organisationId;
@property (nonatomic, readonly) NSString *categoryId;
@property (nonatomic, readonly) NSString *name;
@property (nullable, nonatomic, readonly) NSString *address1;
@property (nullable, nonatomic, readonly) NSString *address2;
@property (nullable, nonatomic, readonly) NSString *town;
@property (nullable, nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *postcode;
@property (nonatomic, readonly) DLSLocationWrapper *location;
@property (nullable, nonatomic, readonly) NSURL *websiteURL;
@property (nullable, nonatomic, readonly) NSString *telephone;
@property (nonatomic, readonly) NSArray<DLSTimetableWrapper *> *openingTimes;
@property (nonatomic, readonly) float distance;

@property (nonatomic, readonly) NSNumber *isHandleMinorAilments;

@property (nullable, nonatomic, readonly) NSString *fullAddress;

- (instancetype)initWithDirectoryService:(DLSDirectoryServiceObject *)object;

+ (instancetype)directoryServiceWithObject:(DLSDirectoryServiceObject *)object;

@end


@interface DLSDirectoryServiceWrapper (DLSDescriptions)

- (nullable NSString *)openingTimesDescription;

@end

NS_ASSUME_NONNULL_END
