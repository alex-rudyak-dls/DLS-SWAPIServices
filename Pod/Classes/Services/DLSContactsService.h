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

- (BFTask<NSArray<DLSContactObject *> *> *)fetchAll;

- (BFTask<DLSContactObject *> *)fetchById:(id)identifier;

- (BFTask *)sendContactInformation:(id)contactInfo;

@end


@interface DLSContactsService : DLSEntityAbstractService <DLSContactsService>

@end

NS_ASSUME_NONNULL_END
