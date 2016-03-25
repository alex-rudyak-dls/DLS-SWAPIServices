//
//  DLSRealmFactory.h
//  Pods
//
//  Created by Alex Rudyak on 3/25/16.
//
//

#import <Foundation/Foundation.h>
#import "DLSConfigurable.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSRealmFactory : NSObject <DLSConfigurable>

@property (nonatomic, strong, readonly) id<DLSServiceConfiguration> serviceConfiguration;

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration;

@end

NS_ASSUME_NONNULL_END