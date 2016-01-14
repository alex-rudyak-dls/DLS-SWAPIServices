//
//  DLSContentTextService.h
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import <DLSEntityAbstractService.h>
#import "DLSApplicationSettingsService.h"


@protocol DLSContentTextService <DLSEntityService>

@property (nonatomic, strong) id<DLSTransport> versionTransport;
@property (nonatomic, strong) id<DLSTransport> contentTransport;
@property (nonatomic, strong) id<DLSApplicationSettingsService> appSettingsService;

- (PMKPromise *)fetchLastVersionContent;

- (PMKPromise *)checkLatestVersion;

@end

@interface DLSContentTextService : DLSEntityAbstractService <DLSContentTextService>

@property (nonatomic, strong) id<DLSTransport> versionTransport;
@property (nonatomic, strong) id<DLSTransport> contentTransport;
@property (nonatomic, strong) id<DLSApplicationSettingsService> appSettingsService;

@end
