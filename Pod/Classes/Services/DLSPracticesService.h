//
//  DLSPracticesService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import "DLSPracticesConstants.h"

@protocol DLSPracticesService <DLSEntityService>

@property (nonatomic, strong) id<DLSTransport> listTransport;
@property (nonatomic, strong) id<DLSTransport> entityTransport;

@property (nonatomic, strong) NSString *organisationId;

- (PMKPromise *)fetchPracticesSorted:(DLSPracticesListSort)sortKey;
- (PMKPromise *)fetchAllPracticePreviews;
- (PMKPromise *)fetchPracticesPreviewSorted:(DLSPracticesListSort)sortKey;

@end


@interface DLSPracticesService : DLSEntityAbstractService <DLSPracticesService>

@property (nonatomic, strong) id<DLSTransport> listTransport;
@property (nonatomic, strong) id<DLSTransport> entityTransport;

@property (nonatomic, strong) NSString *organisationId;

@end
