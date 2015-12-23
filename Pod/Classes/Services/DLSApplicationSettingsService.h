//
//  DLSApplicationSettingsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/6/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSEntityAbstractService.h"

@class DLSApplicationSettingsWrapper;

@protocol DLSApplicationSettingsService <DLSEntityService>

- (PMKPromise *)fetchCurrentAppSettings;

- (PMKPromise *)updateSettings:(DLSApplicationSettingsWrapper *)appSettings;

@end


@interface DLSApplicationSettingsService : DLSEntityAbstractService <DLSApplicationSettingsService>


@end
