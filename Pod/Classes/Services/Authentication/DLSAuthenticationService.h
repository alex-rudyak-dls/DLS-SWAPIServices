//
//  DLSAuthenticationService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>
#import "DLSTransport.h"
#import "DLSAccessTokenWrapper.h"
#import "DLSServiceConfiguration.h"
#import "DLSUserProfileService.h"
#import "DLSApplicationSettingsService.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN NSString *const DLSAuthTokenPathKey;
OBJC_EXTERN NSString *const DLSAuthLogoutPathKey;

@class PMKPromise;
@class DLSAuthCredentials;

@interface DLSAuthenticationService : NSObject

@property (nonatomic, weak) id<DLSUserProfileService> userProfileService;
@property (nonatomic, weak) id<DLSApplicationSettingsService> appSettingsService;

@property (nonatomic, strong, readonly) id<DLSServiceConfiguration> serviceConfiguration;
@property (nullable, nonatomic, strong, readonly) DLSAccessTokenWrapper *token;
@property (nonatomic, readonly, getter=isAuthorized) BOOL authorized;
@property (nonatomic, strong) NSDictionary<NSString *, id<DLSTransport>> *transports;
@property (nullable, nonatomic, readonly) DLSAuthCredentials *credentials;

- (PMKPromise *)authWithCredentials:(DLSAuthCredentials *)credentials;

- (PMKPromise *)restoreAuth;

- (PMKPromise *)checkToken;

- (PMKPromise *)logout;

- (instancetype)initWithConfiguration:(id<DLSServiceConfiguration>)configuration NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype) new NS_UNAVAILABLE;

- (BFTask *)bft_authWithCredentials:(DLSAuthCredentials *)credentials;
- (BFTask *)bft_restoreAuth;
- (BFTask *)bft_checkToken;
- (BFTask *)bft_logout;

@end


@interface DLSAuthCredentials : NSObject <NSCopying>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithCompletion:(nullable void (^)(DLSAuthCredentials *credentials))completion;

@end

NS_ASSUME_NONNULL_END
