//
//  DLSDayTimeWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSTimetableWrapper.h"
#import "DLSTimetableObject.h"


@implementation DLSDayTimeWrapper

+ (instancetype)dayTimeWithObject:(DLSDayTime *)object
{
    return [[self alloc] initWithDayTimeObject:object];
}

- (instancetype)initWithDayTimeObject:(DLSDayTime *)object
{
    self = [self init];
    if (self) {
        _dayName = object.dayName;
        _openTime = object.open;
        _closeTime = object.close;
        _isHoliday = object.isHoliday;
    }
    return self;
}

@end


@implementation DLSTimetableWrapper

+ (instancetype)timetableWithObject:(DLSTimetableObject *)object
{
    return [[self alloc] initWithTimetableObject:object];
}

- (instancetype)initWithTimetableObject:(DLSTimetableObject *)object
{
    self = [self init];
    if (self) {
        NSArray *const dayNames = @[ @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday" ];
        _days = @[
            [DLSDayTimeWrapper dayTimeWithObject:object.monday],
            [DLSDayTimeWrapper dayTimeWithObject:object.tuesday],
            [DLSDayTimeWrapper dayTimeWithObject:object.wednesday],
            [DLSDayTimeWrapper dayTimeWithObject:object.thursday],
            [DLSDayTimeWrapper dayTimeWithObject:object.friday],
            [DLSDayTimeWrapper dayTimeWithObject:object.saturday],
            [DLSDayTimeWrapper dayTimeWithObject:object.sunday]
        ];
        [_days enumerateObjectsUsingBlock:^(DLSDayTimeWrapper *obj, NSUInteger idx, BOOL *stop) {
            [obj setDayName:dayNames[idx]];
        }];
    }
    return self;
}

@end


@implementation DLSTimetableWrapper (DLSStringDescriptions)

- (NSString *)shortTimetable
{
    NSMutableArray *globalTimetable = [NSMutableArray array];
    __block NSMutableArray *localTimes = [NSMutableArray array];
    __block DLSDayTimeWrapper *previousTime;
    [self.days enumerateObjectsUsingBlock:^(DLSDayTimeWrapper *time, NSUInteger idx, BOOL *stop) {
        if (!time.isHoliday && (!previousTime || ([time.openTime isEqualToString:previousTime.openTime] && [time.closeTime isEqualToString:previousTime.closeTime]))) {
            [localTimes addObject:time];
        } else {
            [globalTimetable addObject:localTimes];
            localTimes = [NSMutableArray array];
            if (!time.isHoliday) {
                [localTimes addObject:time];
            }
        }
        previousTime = time.isHoliday ? nil : time;
    }];

    NSMutableString *timetableDescription = [NSMutableString string];
    for (NSMutableArray *timeRanges in globalTimetable) {
        if (timeRanges.count == 1) {
            DLSDayTimeWrapper *time = [timeRanges firstObject];
            [timetableDescription appendFormat:@"%@ %@ - %@\n", time.dayName, time.openTime, time.closeTime];
        } else if (timeRanges.count > 1) {
            DLSDayTimeWrapper *const beginTime = [timeRanges firstObject];
            DLSDayTimeWrapper *const endTime = [timeRanges lastObject];
            [timetableDescription appendFormat:@"%@ to %@ %@ - %@\n", beginTime.dayName, endTime.dayName, beginTime.openTime, endTime.closeTime];
        }
    }

    return timetableDescription.length ? [timetableDescription substringWithRange:NSMakeRange(0, timetableDescription.length - 1)] : timetableDescription;
}

@end
