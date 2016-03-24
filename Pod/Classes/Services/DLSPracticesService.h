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

- (BFTask<NSArray<DLSPracticeWrapper *> *> *)fetchAll;

- (BFTask<DLSPracticeWrapper *> *)fetchById:(id)identifier;

- (BFTask<NSArray<DLSPracticeWrapper *> *> *)fetchPracticesSorted:(DLSPracticesListSort)sortKey;

- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)fetchAllPracticePreviews;

- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)fetchPracticesPreviewSorted:(DLSPracticesListSort)sortKey;

- (BFTask<NSArray<DLSPracticeShortWrapper *> *> *)fetchPracticesPreviewWhichIsOnlyPartOfHub:(BOOL)isOnlyPartOfHub;

@end


@interface DLSPracticesService : DLSEntityAbstractService <DLSPracticesService>

@property (nonatomic, strong) id<DLSTransport> listTransport;
@property (nonatomic, strong) id<DLSTransport> entityTransport;

@property (nonatomic, strong) NSString *organisationId;

@end

NS_ASSUME_NONNULL_END
