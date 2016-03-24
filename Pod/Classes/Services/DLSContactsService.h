//
//  DLSContactsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"
#import <Bolts/BFTask.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSContactObject;

@protocol DLSContactsService <DLSEntityService>

- (PMKPromise *)sendContactInformation:(id)contactInfo;

- (BFTask<NSArray<DLSContactObject *> *> *)bft_fetchAll;
- (BFTask<DLSContactObject *> *)bft_fetchById:(id)identifier;
- (BFTask *)bft_sendContactInformation:(id)contactInfo;

@end


@interface DLSContactsService : DLSEntityAbstractService <DLSContactsService>

@end

NS_ASSUME_NONNULL_END