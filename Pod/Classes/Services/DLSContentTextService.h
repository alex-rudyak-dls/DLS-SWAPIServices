//
//  DLSContentTextService.h
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import <DLSEntityAbstractService.h>
#import <Bolts/BFTask.h>
#import "DLSApplicationSettingsService.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSApplicationContentObject;

@protocol DLSContentTextService <DLSEntityService>

@property (nonatomic, strong) id<DLSTransport> versionTransport;
@property (nonatomic, strong) id<DLSTransport> contentTransport;
@property (nonatomic, strong) id<DLSApplicationSettingsService> appSettingsService;

- (PMKPromise *)fetchLastVersionContent;

- (PMKPromise *)checkLatestVersion;

- (BFTask<NSArray<DLSApplicationContentObject *> *> *)bft_fetchAll;
- (BFTask<DLSApplicationContentObject *> *)bft_fetchById:(id)identifier;
- (BFTask<DLSApplicationContentObject *> *)bft_fetchLastVersionContent;
- (BFTask<NSNumber *> *)bft_checkLatestVersion;


@end

@interface DLSContentTextService : DLSEntityAbstractService <DLSContentTextService>

@property (nonatomic, strong) id<DLSTransport> versionTransport;
@property (nonatomic, strong) id<DLSTransport> contentTransport;
@property (nonatomic, strong) id<DLSApplicationSettingsService> appSettingsService;

@end

NS_ASSUME_NONNULL_END
