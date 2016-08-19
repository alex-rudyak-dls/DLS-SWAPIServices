//
//  DLSDirectoryServiceWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSDirectoryServiceWrapper.h"
#import "DLSTimetableWrapper.h"
#import "DLSLocationWrapper.h"
#import "DLSDirectoryServiceObject.h"
#import "DLSTimetableObject.h"


@implementation DLSDirectoryServiceWrapper
@dynamic fullAddress;

+ (instancetype)directoryServiceWithObject:(DLSDirectoryServiceObject *)object
{
    return [[self alloc] initWithDirectoryService:object];
}

- (instancetype)initWithDirectoryService:(DLSDirectoryServiceObject *)object
{
    self = [self init];
    if (self) {
        _directoryId = object.id;
        _organisationId = object.organisationId;
        _categoryId = object.categoryId;
        _name = object.name;
        _address1 = object.address1;
        _address2 = object.address2;
        _town = object.town;
        _country = object.country;
        _postcode = object.postcode;
        _location = [DLSLocationWrapper locationWithObject:object.location];
        _websiteURL = [NSURL URLWithString:object.website];
        _telephone = object.telephone;
        _distance = object.distance;
        if (object.isHandleMinorAilments) {
            _isHandleMinorAilments = object.isHandleMinorAilments;
        }

        NSMutableArray *openingTimes = [NSMutableArray arrayWithCapacity:object.openingTimes.count];
        for (DLSTimetableObject *timetable in object.openingTimes) {
            [openingTimes addObject:[DLSTimetableWrapper timetableWithObject:timetable]];
        }
        _openingTimes = [NSArray arrayWithArray:openingTimes];

        _openingTimesText = object.openingTimesText;
        _serviceDescription = object.serviceDescription;
    }
    return self;
}

- (NSString *)fullAddress
{
    NSMutableArray *address = [NSMutableArray array];
    if (self.address1.length) {
        [address addObject:self.address1];
    }
    if (self.address2.length) {
        [address addObject:self.address2];
    }
    return [address componentsJoinedByString:@", "];
}

@end


@implementation DLSDirectoryServiceWrapper (DLSDescriptions)

- (NSString *)openingTimesDescription
{
    return [[self.openingTimes firstObject] shortTimetable];
}

@end
