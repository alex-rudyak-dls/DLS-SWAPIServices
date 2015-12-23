//
//  DLSUserProfileWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSUserProfileObject;


@interface DLSUserProfileWrapper : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *gp;
@property (nonatomic, strong) NSString *sub;
@property (nonatomic, strong) NSDate *dateOfBirth;

@property (nonatomic, readonly) NSString *fullName;

- (instancetype)initWithUser:(DLSUserProfileObject *)object;

+ (instancetype)userWithObject:(DLSUserProfileObject *)object;

- (DLSUserProfileObject *)userProfileObject;

@end
