//
//  DLSDayTimeWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSDayTime;
@class DLSTimetableObject;

@interface DLSDayTimeWrapper : NSObject

@property (nonatomic, strong) NSString *dayName;
@property (nonatomic, readonly) NSString *openTime;
@property (nonatomic, readonly) NSString *closeTime;
@property (nonatomic, readonly) BOOL isHoliday;

- (instancetype)initWithDayTimeObject:(DLSDayTime *)object;

+ (instancetype)dayTimeWithObject:(DLSDayTime *)object;

@end


@interface DLSTimetableWrapper : NSObject

@property (nonatomic, readonly) NSArray<DLSDayTimeWrapper *> *days;

- (instancetype)initWithTimetableObject:(DLSTimetableObject *)object;

+ (instancetype)timetableWithObject:(DLSTimetableObject *)object;

@end


@interface DLSTimetableWrapper (DLSStringDescriptions)

- (nullable NSString *)shortTimetable;

@end

NS_ASSUME_NONNULL_END
