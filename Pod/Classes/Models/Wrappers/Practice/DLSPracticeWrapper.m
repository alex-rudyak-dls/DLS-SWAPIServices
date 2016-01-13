//
//  DLSPracticeWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticeWrapper.h"
#import "DLSTimetableWrapper.h"
#import "DLSPracticeObject.h"


@implementation DLSPracticeWrapper

+ (instancetype)practiceWithObject:(DLSPracticeObject *)object
{
    return [[self alloc] initWithPractice:object];
}

- (instancetype)initWithPractice:(DLSPracticeObject *)object
{
    self = [self init];
    if (self) {
        _practiceId = object.id;
        _name = object.name;
        _address1 = object.address1;
        _address2 = object.address2;
        _town = object.town;
        _country = object.country;
        _postcode = object.postcode;
        _area = object.area;
        _websiteURL = [NSURL URLWithString:object.website];
        _registrationURL = [NSURL URLWithString:object.registrationLink];
        _imageURL = [NSURL URLWithString:object.imageURL];
        _telephone = object.telephone;
        _openingTimes = object.openingTimes;
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


@implementation DLSPracticeWrapper (DLSDescriptions)

- (NSString *)openingTimesDescription
{
    return self.openingTimes;
}

@end
