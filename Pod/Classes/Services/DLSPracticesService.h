//
//  DLSPracticesService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import "DLSPracticesConstants.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSPracticeWrapper;
@class DLSPracticeShortWrapper;

@protocol DLSPracticesService <DLSEntityService>

@property (nonatomic, strong) id<DLSTransport> listTransport;
@property (nonatomic, strong) id<DLSTransport> entityTransport;

@property (nonatomic, strong) NSString *organisationId;

- (PMKPromise *)fetchPracticesSorted:(DLSPracticesListSort)sortKey;
- (PMKPromise *)fetchAllPracticePreviews;
- (PMKPromise *)fetchPracticesPreviewSorted:(DLSPracticesListSort)sortKey;
- (PMKPromise *)fetchPracticesPreviewWhichIsOnlyPartOfHub:(BOOL)isOnlyPartOfHub;

- (BFTask<NSArray<DLSPracticeWrapper *> *> *)bft_fetchAll;
- (BFTask<DLSPracticeWrapper *> *)bft_fetchById:(id)identifier;
- (BFTask<NSArray<DLSPracticeWrapper *> *> *)bft_fetchPracticesSorted:(DLSPracticesListSort)sortKey;
- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)bft_fetchAllPracticePreviews;
- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)bft_fetchPracticesPreviewSorted:(DLSPracticesListSort)sortKey;
- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)bft_fetchPracticesPreviewWhichIsOnlyPartOfHub:(BOOL)isOnlyPartOfHub;

@end


@interface DLSPracticesService : DLSEntityAbstractService <DLSPracticesService>

@property (nonatomic, strong) id<DLSTransport> listTransport;
@property (nonatomic, strong) id<DLSTransport> entityTransport;

@property (nonatomic, strong) NSString *organisationId;

@end

NS_ASSUME_NONNULL_END
