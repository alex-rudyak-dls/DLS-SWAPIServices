//
//  DLSAuthenticationService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import "DLSTransport.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSString *const DLSAuthTokenPathKey;
OBJC_EXTERN NSString *const DLSAuthLogoutPathKey;

@class DLSAuthCredentials;
@class DLSAccessTokenWrapper;
@protocol DLSServiceConfiguration;
@protocol DLSUserProfileService;
@protocol DLSApplicationSettingsService;

@interface DLSAuthenticationService : NSObject

@property (nonatomic, weak) id<DLSUserProfileService> userProfileService;
@property (nonatomic, weak) id<DLSApplicationSettingsService> appSettingsService;

@property (nonatomic, strong, readonly) id<DLSServiceConfiguration> serviceConfiguration;
@property (nullable, nonatomic, strong, readonly) DLSAccessTokenWrapper *token;
@property (nonatomic, readonly, getter=isAuthorized) BOOL authorized;
@property (nonatomic, strong) NSDictionary<NSString *, id<DLSTransport>> *transports;
@property (nullable, nonatomic, readonly) DLSAuthCredentials *credentials;

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

- (BFTask *)authWithCredentials:(DLSAuthCredentials *)credentials;

- (BFTask *)restoreAuth;

- (BFTask *)checkToken;

- (BFTask *)logout;

@end

NS_ASSUME_NONNULL_END
