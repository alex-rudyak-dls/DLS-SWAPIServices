//
//  DLSContactsService.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/17/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSEntityAbstractService.h"

@protocol DLSContactsService <DLSEntityService>

- (PMKPromise *)sendContactInformation:(id)contactInfo;

@end


@interface DLSContactsService : DLSEntityAbstractService <DLSContactsService>

@end
