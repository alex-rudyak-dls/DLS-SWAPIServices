//
//  DLSLocationWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSLocationWrapper.h"
#import "DLSDirectoryServiceObject.h"
#import <CoreLocation/CoreLocation.h>


@implementation DLSLocationWrapper

+ (instancetype)locationWithObject:(DLSLocationObject *)object
{
    return [[self alloc] initWithLocationObject:object];
}

- (instancetype)initWithLocationObject:(DLSLocationObject *)object
{
    self = [self init];
    if (self) {
        _latitude = object.lat;
        _longitude = object.lng;
    }
    return self;
}

@end


@implementation DLSLocationWrapper (DLSCoreLocaation)

- (instancetype)initWithCoreLocation:(CLLocation *)location
{
    self = [self init];
    if (self) {
        _latitude = location.coordinate.latitude;
        _longitude = location.coordinate.longitude;
    }
    return self;
}

@end
