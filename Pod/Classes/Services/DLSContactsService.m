//
//  DLSContactsService.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSContactsService.h"
#import "DLSEntityAbstractService_Private.h"
#import "DLSAuthenticationService.h"
#import "DLSContactObject.h"
#import "DLSAccessTokenWrapper.h"


OBJC_IMPORT NSString *DLSApiRequestSource;


@implementation DLSContactsService

- (BFTask<DLSContactObject *> *)sendContactInformation:(id)contactInfo
{
    return [[self.authService checkToken] continueWithExecutor:self.fetchExecutor withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
        NSDictionary *const entity = [EKSerializer serializeObject:contactInfo withMapping:[DLSContactObject objectMapping]];
        NSMutableDictionary *mutableEntity = [entity mutableCopy];
        mutableEntity[@"source"] = DLSApiRequestSource;
        
        [self.transport setAuthorizationHeader:[self.authService.token authenticationHeaderValue]];
        
        return [self.transport create:entity];
    }];
}

@end
