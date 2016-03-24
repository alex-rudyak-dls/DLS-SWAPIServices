//
//  DLSAppointmentRequestsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSAppointmentObject;
@class DLSAnonymousAppointmentObject;

@protocol DLSAppointmentsService <DLSEntityService>

- (BFTask<NSArray<DLSAppointmentObject *> *> *)fetchAll;

- (BFTask<DLSAppointmentObject *> *)fetchById:(id)identifier;

- (BFTask<DLSAppointmentObject *> *)createNewAppointmentRequest:(DLSAppointmentObject *)appointmentRequest;

- (BFTask<DLSAppointmentObject *> *)createAnonymousAppointmentRequest:(DLSAnonymousAppointmentObject *)appointmentRequest;

@end


@interface DLSAppointmentsService : DLSEntityAbstractService <DLSAppointmentsService>

@end

NS_ASSUME_NONNULL_END
