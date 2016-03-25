//
//  DLSConfigurable.h
//  Pods
//
//  Created by Alex Rudyak on 3/25/16.
//
//

#import <Foundation/Foundation.h>

@class RLMRealm;
@protocol DLSServiceConfiguration;

@protocol DLSConfigurable <NSObject>

@property (nonatomic, strong, readonly) id<DLSServiceConfiguration> serviceConfiguration;

- (RLMRealm *)realmInstance:(NSError **)error;

@end
