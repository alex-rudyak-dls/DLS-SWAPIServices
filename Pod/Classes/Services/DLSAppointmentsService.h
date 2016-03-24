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

- (BFTask<NSArray<DLSAppointmentObject *> *> *)bft_fetchAll;

- (BFTask<DLSAppointmentObject *> *)bft_fetchById:(id)identifier;

- (BFTask<DLSAppointmentObject *> *)bft_createNewAppointmentRequest:(DLSAppointmentObject *)appointmentRequest;

- (BFTask<DLSAppointmentObject *> *)bft_createAnonymousAppointmentRequest:(DLSAnonymousAppointmentObject *)appointmentRequest;

@end


@interface DLSAppointmentsService : DLSEntityAbstractService <DLSAppointmentsService>

@end

NS_ASSUME_NONNULL_END
