//
//  DLSAppointmentRequestsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/9/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSAppointmentsService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSEntityAbstractService_Private.h"
#import "DLSAppointmentObject.h"
#import "DLSAuthenticationService.h"
#import "DLSAnonymousAppointmentObject.h"
#import "DLSApiConstants.h"


@implementation DLSAppointmentsService

- (PMKPromise *)fetchAll
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchAllWithParams:nil];
    }).thenOn(self.fetchQueue, ^(id response) {
        NSArray<DLSAppointmentObject *> *appointments = [EKMapper arrayOfObjectsFromExternalRepresentation:response withMapping:[DLSAppointmentObject objectMapping]];
        return appointments;
    }).thenOn(self.responseQueue, ^(NSArray *appointments) {
        [self _successWithResponse:appointments completion:nil];
        return [PMKPromise promiseWithValue:appointments];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
}

- (PMKPromise *)fetchById:(id)identifier
{
    return [super fetchById:identifier].thenOn(self.fetchQueue, ^() {
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport fetchWithId:identifier];
    }).thenOn(self.fetchQueue, ^(id response) {
        DLSAppointmentObject *appointment = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSAppointmentObject objectMapping]];
        return appointment;
    }).thenOn(self.responseQueue, ^(DLSAppointmentObject *appointment) {
        [self _successWithResponse:appointment completion:nil];
        return [PMKPromise promiseWithValue:appointment];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
}

- (PMKPromise *)createNewAppointmentRequest:(DLSAppointmentObject *)appointmentRequest
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        NSMutableDictionary *appointmentDict = [EKSerializer serializeObject:appointmentRequest withMapping:[DLSAppointmentObject objectMapping]].mutableCopy;
        appointmentDict[@"request_source"] = DLSApiRequestSource;
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport create:appointmentDict];
    }).thenOn(self.fetchQueue, ^(id response) {
        DLSAnonymousAppointmentObject *registeredAppointment = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSAnonymousAppointmentObject objectMapping]];
        return registeredAppointment;
    }).thenOn(self.responseQueue, ^(DLSAnonymousAppointmentObject *appointment) {
        [self _successWithResponse:appointment completion:nil];
        return [PMKPromise promiseWithValue:appointment];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
}

- (PMKPromise *)createAnonymousAppointmentRequest:(DLSAnonymousAppointmentObject *)appointmentRequest
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        NSMutableDictionary *appointmentDict = [EKSerializer serializeObject:appointmentRequest withMapping:[DLSAnonymousAppointmentObject objectMapping]].mutableCopy;
        appointmentDict[@"request_source"] = DLSApiRequestSource;
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport create:appointmentDict];
    }).thenOn(self.fetchQueue, ^(id response) {
        DLSAnonymousAppointmentObject *registeredAppointment = [EKMapper objectFromExternalRepresentation:response withMapping:[DLSAnonymousAppointmentObject objectMapping]];
        return registeredAppointment;
    }).thenOn(self.responseQueue, ^(DLSAnonymousAppointmentObject *appointment) {
        [self _successWithResponse:appointment completion:nil];
        return [PMKPromise promiseWithValue:appointment];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        [self _failWithError:error inMethod:_cmd completion:nil];
        @throw error;
    });
}

@end
