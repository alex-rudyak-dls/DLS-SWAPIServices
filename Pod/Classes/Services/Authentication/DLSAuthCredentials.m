//
//  DLSAuthCredentials.m
//  Pods
//
//  Created by Alex Rudyak on 3/25/16.
//
//

#import "DLSAuthCredentials.h"

@implementation DLSAuthCredentials

- (instancetype)initWithCompletion:(void (^)(DLSAuthCredentials *))completion
{
    self = [super init];
    if (self && completion) {
        completion(self);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DLSAuthCredentials *copyInstance = [[DLSAuthCredentials alloc] initWithCompletion:^(DLSAuthCredentials *credentials) {
        credentials.username = [self.username copy];
        credentials.password = [self.password copy];
    }];
    return copyInstance;
}

@end
