//
//  DLSAppointmentRequestsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"

@class DLSAppointmentObject;
@class DLSAnonymousAppointmentObject;

@protocol DLSAppointmentsService <DLSEntityService>

- (PMKPromise *)createNewAppointmentRequest:(DLSAppointmentObject *)appointmentRequest;
- (PMKPromise *)createAnonymousAppointmentRequest:(DLSAnonymousAppointmentObject *)appointmentRequest;

@end


@interface DLSAppointmentsService : DLSEntityAbstractService <DLSAppointmentsService>

@end
