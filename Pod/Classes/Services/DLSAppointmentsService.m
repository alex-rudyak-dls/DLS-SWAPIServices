//
//  DLSAppointmentRequestsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAppointmentsService.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSAppointmentObject.h"
#import "DLSAuthenticationService.h"
#import "DLSAnonymousAppointmentObject.h"
#import "DLSApiErrors.h"


@implementation DLSAppointmentsService

- (BFTask *)bft_fetchAll
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchAllWithParams:nil];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSArray<DLSAppointmentObject *> *appointments = [EKMapper arrayOfObjectsFromExternalRepresentation:task.result withMapping:[DLSAppointmentObject objectMapping]];
        return appointments;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask *)bft_fetchById:(id)identifier
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_fetchWithId:identifier];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAppointmentObject *appointment = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAppointmentObject objectMapping]];
        return appointment;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask<DLSAppointmentObject *> *)bft_createNewAppointmentRequest:(DLSAppointmentObject *)appointmentRequest
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const appointmentDict = [EKSerializer serializeObject:appointmentRequest withMapping:[DLSAppointmentObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_create:appointmentDict];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAnonymousAppointmentObject *const registeredAppointment = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAnonymousAppointmentObject objectMapping]];
        return registeredAppointment;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

- (BFTask<DLSAppointmentObject *> *)bft_createAnonymousAppointmentRequest:(DLSAnonymousAppointmentObject *)appointmentRequest
{
    return [[[[self.authService bft_checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const appointmentDict = [EKSerializer serializeObject:appointmentRequest withMapping:[DLSAnonymousAppointmentObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport bft_create:appointmentDict];
    }] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        DLSAnonymousAppointmentObject *const registeredAppointment = [EKMapper objectFromExternalRepresentation:task.result withMapping:[DLSAnonymousAppointmentObject objectMapping]];
        return registeredAppointment;
    }] continueWithExecutor:self.responseExecutor withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.isFaulted || task.isCancelled) {
            return [self _failOfTask:task inMethod:_cmd];
        }
        return [self _successWithResponse:task.result];
    }];
}

@end
