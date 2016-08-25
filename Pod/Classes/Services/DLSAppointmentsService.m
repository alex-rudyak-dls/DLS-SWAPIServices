//
//  DLSAppointmentRequestsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAppointmentsService.h"
#import <Bolts/Bolts.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSAppointmentObject.h"
#import "DLSAuthenticationService.h"
#import "DLSAnonymousAppointmentObject.h"
#import "DLSApiErrors.h"
#import "DLSAccessTokenWrapper.h"


OBJC_IMPORT NSString *DLSApiRequestSource;


@implementation DLSAppointmentsService

- (BFTask *)fetchAll
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSAppointmentObject *> *const appointments = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSAppointmentObject objectMapping]];

        return appointments;
    }];
}

- (BFTask *)fetchById:(id)identifier
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport fetchWithId:identifier];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAppointmentObject *const appointment = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAppointmentObject objectMapping]];

        return appointment;
    }];
}

- (BFTask<DLSAppointmentObject *> *)createNewAppointmentRequest:(DLSAppointmentObject *)appointmentRequest
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const appointmentDict = [EKSerializer serializeObject:appointmentRequest withMapping:[DLSAppointmentObject objectMapping]];
        NSMutableDictionary *mutableAppointmentDict = [appointmentDict mutableCopy];
        mutableAppointmentDict[@"request_source"] = DLSApiRequestSource;

        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];

        return [self.transport create:mutableAppointmentDict];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAnonymousAppointmentObject *const registeredAppointment = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAnonymousAppointmentObject objectMapping]];

        return registeredAppointment;
    }];
}

- (BFTask<DLSAppointmentObject *> *)createAnonymousAppointmentRequest:(DLSAnonymousAppointmentObject *)appointmentRequest
{
    return [[[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const appointmentDict = [EKSerializer serializeObject:appointmentRequest withMapping:[DLSAnonymousAppointmentObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        NSMutableDictionary *mutableAppointmentDict = [appointmentDict mutableCopy];
        mutableAppointmentDict[@"request_source"] = DLSApiRequestSource;

        return [self.transport create:mutableAppointmentDict];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAnonymousAppointmentObject *const registeredAppointment = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAnonymousAppointmentObject objectMapping]];

        return registeredAppointment;
    }];
}

@end
