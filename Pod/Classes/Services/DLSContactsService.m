//
//  DLSContactsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSContactsService.h"
#import <PromiseKit/PromiseKit.h>
#import "DLSAuthenticationService.h"
#import "DLSContactObject.h"


@implementation DLSContactsService

- (PMKPromise *)sendContactInformation:(id)contactInfo
{
    return [super fetchAll].thenOn(self.fetchQueue, ^() {
        NSDictionary *entity = [EKSerializer serializeObject:contactInfo withMapping:[DLSContactObject objectMapping]];
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        return [self.transport create:entity];
    }).thenOn(self.responseQueue, ^(id response) {
        return [PMKPromise promiseWithValue:@YES];
    }).catchOn(self.responseQueue, ^(NSError *error) {
        @throw error;
    });
}

@end
