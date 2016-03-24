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

- (BFTask<NSArray<DLSApplicationSettingsWrapper *> *> *)fetchAll;

- (BFTask<DLSApplicationSettingsWrapper *> *)fetchById:(id)identifier;

- (BFTask<DLSApplicationSettingsWrapper *> *)fetchCurrentAppSettings;

- (BFTask<DLSApplicationSettingsWrapper *> *)updateSettings:(DLSApplicationSettingsWrapper *)appSettings;

@end


@interface DLSApplicationSettingsService : DLSEntityAbstractService <DLSApplicationSettingsService>

@end

NS_ASSUME_NONNULL_END
