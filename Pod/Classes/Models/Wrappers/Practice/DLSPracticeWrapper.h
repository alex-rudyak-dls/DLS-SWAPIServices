//
//  DLSPracticeWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSPracticeObject;
@class DLSTimetableWrapper;

@protocol DLSPracticeWrapper <NSObject>

@property (nonatomic, readonly) NSString *practiceId;

- (instancetype)initWithPractice:(DLSPracticeObject *)object;

+ (instancetype)practiceWithObject:(DLSPracticeObject *)object;

@end


@interface DLSPracticeWrapper : NSObject <DLSPracticeWrapper>

@property (nonatomic, readonly) NSString *practiceId;
@property (nonatomic, readonly) NSString *handleId;
@property (nonatomic, readonly) NSString *name;
@property (nullable, nonatomic, readonly) NSString *address1;
@property (nullable, nonatomic, readonly) NSString *address2;
@property (nullable, nonatomic, readonly) NSString *town;
@property (nullable, nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *postcode;
@property (nullable, nonatomic, readonly) NSString *area;
@property (nullable, nonatomic, readonly) NSURL *websiteURL;
@property (nullable, nonatomic, readonly) NSURL *registrationURL;
@property (nullable, nonatomic, readonly) NSURL *imageURL;
@property (nullable, nonatomic, readonly) NSString *telephone;
@property (nullable, nonatomic, readonly) NSString *openingTimes;
@property (nonatomic, readonly, getter=isPartOfHub) BOOL partOfHub;

@property (nullable, nonatomic, readonly) NSString *fullAddress;

@end


@interface DLSPracticeWrapper (DLSDescriptions)

- (nullable NSString *)openingTimesDescription;

@end

NS_ASSUME_NONNULL_END
