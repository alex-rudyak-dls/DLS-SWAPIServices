//
//  DLSPracticeWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSPracticeObject;
@class DLSTimetableWrapper;

@protocol DLSPracticeWrapper <NSObject>

@property (nonatomic, readonly) NSString *practiceId;

- (instancetype)initWithPractice:(DLSPracticeObject *)object;

+ (instancetype)practiceWithObject:(DLSPracticeObject *)object;

@end


@interface DLSPracticeWrapper : NSObject <DLSPracticeWrapper>

@property (nonatomic, readonly) NSString *practiceId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *address1;
@property (nonatomic, readonly) NSString *address2;
@property (nonatomic, readonly) NSString *town;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *postcode;
@property (nonatomic, readonly) NSString *area;
@property (nonatomic, readonly) NSURL *websiteURL;
@property (nonatomic, readonly) NSURL *registrationURL;
@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) NSString *telephone;
@property (nonatomic, readonly) NSString *openingTimes;

@property (nonatomic, readonly) NSString *fullAddress;

@end


@interface DLSPracticeWrapper (DLSDescriptions)

- (NSString *)openingTimesDescription;

@end
