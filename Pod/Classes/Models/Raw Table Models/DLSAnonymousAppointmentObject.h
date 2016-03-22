//
//  DLSAnonymousAppointmentObject.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/10/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAppointmentObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSAnonymousAppointmentObject : DLSAppointmentObject <EKMappingProtocol>

@property NSString *firstName;
@property NSString *lastName;
@property NSDate *dateOfBirth;
@property NSString *gender;
@property NSString *gp;
@property NSString *email;

@end

NS_ASSUME_NONNULL_END
