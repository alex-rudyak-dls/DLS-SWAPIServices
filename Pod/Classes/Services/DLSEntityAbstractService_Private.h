//
//  DLSEntityAbstractService_Private.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/8/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSEntityAbstractService.h"


@interface DLSEntityAbstractService ()

- (void)_failWithError:(NSError *)error completion:(void (^)(NSError *error))completion;

- (void)_failWithError:(NSError *)error inMethod:(SEL)methodSelector completion:(void (^)(NSError *))completion;

- (void)_successWithResponse:(id)response completion:(void (^)(id response))completion;

@end
