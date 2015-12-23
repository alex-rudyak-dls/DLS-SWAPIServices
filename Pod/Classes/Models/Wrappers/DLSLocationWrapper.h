//
//  DLSLocationWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSLocationObject;

@class CLLocation;


@interface DLSLocationWrapper : NSObject

@property (nonatomic, readonly) float longitude;
@property (nonatomic, readonly) float latitude;

- (instancetype)initWithLocationObject:(DLSLocationObject *)object;

+ (instancetype)locationWithObject:(DLSLocationObject *)object;

@end


@interface DLSLocationWrapper (DLSCoreLocaation)

- (instancetype)initWithCoreLocation:(CLLocation *)location;

@end
