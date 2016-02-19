//
//  DLSUserProfileWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSUserProfileWrapper.h"
#import "DLSUserProfileObject.h"


@implementation DLSUserProfileWrapper
@dynamic fullName;

+ (instancetype)userWithObject:(DLSUserProfileObject *)object
{
    return [[self alloc] initWithUser:object];
}

- (instancetype)initWithUser:(DLSUserProfileObject *)object
{
    self = [self init];
    if (self) {
        self.firstName = object.firstName;
        self.lastName = object.lastName;
        self.email = object.email;
        self.phone = object.phone;
        self.skype = object.skype;
        self.gender = object.gender;
        self.gp = object.gp;
        self.sub = object.sub;
        self.dateOfBirth = object.dateOfBirth;
    }
    return self;
}

- (DLSUserProfileObject *)userProfileObject
{
    DLSUserProfileObject *object = [DLSUserProfileObject new];
    object.firstName = self.firstName;
    object.lastName = self.lastName;
    object.email = self.lastName;
    object.phone = self.phone;
    object.skype = self.skype;
    object.gender = self.gender;
    object.gp = self.gp;
    object.sub = self.sub;
    object.dateOfBirth = self.dateOfBirth;
    return object;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
