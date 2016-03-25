//
//  DLSRealmFactory.m
//  Pods
//
//  Created by Alex Rudyak on 3/25/16.
//
//

#import "DLSRealmFactory.h"
#import <Realm/Realm.h>
#import "DLSApiErrors.h"
#import "DLSServiceConfiguration.h"

@implementation DLSRealmFactory

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _serviceConfiguration = configuration;

    return self;
}

- (RLMRealm *)realmInstance:(NSError *__autoreleasing *)error
{
    NSError *realmError = nil;
    RLMRealm *const realm = [RLMRealm realmWithConfiguration:self.serviceConfiguration.realmConfiguration error:&realmError];
    if (realmError) {
        *error = [NSError errorWithDomainPostfix:@"persistence.error" code:DLSSouthWorcestershireErrorCodePersistence userInfo:@{ NSLocalizedDescriptionKey: @"The app couldn't perform any persistence operations.", NSUnderlyingErrorKey: realmError }];
        return nil;
    }

    return realm;
}

@end
