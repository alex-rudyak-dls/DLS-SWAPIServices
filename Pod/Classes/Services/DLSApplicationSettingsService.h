//
//  DLSApplicationSettingsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/BFTask.h>
#import "DLSEntityAbstractService.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSApplicationSettingsWrapper;

@protocol DLSApplicationSettingsService <DLSEntityService>

- (PMKPromise *)fetchCurrentAppSettings;

- (PMKPromise *)updateSettings:(DLSApplicationSettingsWrapper *)appSettings;

- (BFTask<NSArray<DLSApplicationSettingsWrapper *> *> *)bft_fetchAll;
- (BFTask<DLSApplicationSettingsWrapper *> *)bft_fetchById:(id)identifier;
- (BFTask<DLSApplicationSettingsWrapper *> *)bft_fetchCurrentAppSettings;
- (BFTask<DLSApplicationSettingsWrapper *> *)bft_updateSettings:(DLSApplicationSettingsWrapper *)appSettings;

@end


@interface DLSApplicationSettingsService : DLSEntityAbstractService <DLSApplicationSettingsService>

@end

NS_ASSUME_NONNULL_END
