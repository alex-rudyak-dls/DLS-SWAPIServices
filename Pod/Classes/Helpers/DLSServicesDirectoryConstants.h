//
//  DLSServicesDirectoryConstants.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/11/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#ifndef DLSServicesDirectoryConstants_h
#define DLSServicesDirectoryConstants_h

typedef NS_OPTIONS(NSUInteger, DLSServiceDirectoryAction) {
    DLSServiceDirectoryActionSort = 1 << 1,
    DLSServiceDirectoryActionFilter = 1 << 2,
    DLSServiceDirectoryActionAll = DLSServiceDirectoryActionSort | DLSServiceDirectoryActionFilter,
};

typedef NS_ENUM(NSUInteger, DLSServiceDirectorySort) {
    DLSServiceDirectorySortAlphabetical,
    DLSServiceDirectorySortDistance,
    DLSServiceDirectorySortDefault = DLSServiceDirectorySortDistance
};

typedef NS_OPTIONS(NSUInteger, DLSServiceDirectoryFiltration) {
    DLSServiceDirectoryFiltrationNone = 1 << 0,
    DLSServiceDirectoryFiltrationOpenNow = 1 << 1,
    DLSServiceDirectoryFiltrationMinorAilment = 1 << 2,
    DLSServiceDirectoryFiltrationDefault = DLSServiceDirectoryFiltrationNone
};

#endif /* DLSServicesDirectoryConstants_h */
