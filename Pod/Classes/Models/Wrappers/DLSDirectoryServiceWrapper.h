//
//  DLSDirectoryServiceWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSLocationWrapper.h"

@class DLSDirectoryServiceObject;
@class DLSTimetableWrapper;


@interface DLSDirectoryServiceWrapper : NSObject

@property (nonatomic, readonly) NSString *directoryId;
@property (nonatomic, readonly) NSString *organisationId;
@property (nonatomic, readonly) NSString *categoryId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *address1;
@property (nonatomic, readonly) NSString *address2;
@property (nonatomic, readonly) NSString *town;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *postcode;
@property (nonatomic, readonly) DLSLocationWrapper *location;
@property (nonatomic, readonly) NSURL *websiteURL;
@property (nonatomic, readonly) NSString *telephone;
@property (nonatomic, readonly) NSArray<DLSTimetableWrapper *> *openingTimes;
@property (nonatomic, readonly) float distance;

@property (nonatomic, readonly) NSNumber *isHandleMinorAilments;

@property (nonatomic, readonly) NSString *fullAddress;

- (instancetype)initWithDirectoryService:(DLSDirectoryServiceObject *)object;

+ (instancetype)directoryServiceWithObject:(DLSDirectoryServiceObject *)object;

@end


@interface DLSDirectoryServiceWrapper (DLSDescriptions)

- (NSString *)openingTimesDescription;

@end
