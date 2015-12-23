//
//  DLSServiceLayer.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSServiceLayer.h"
#import <PromiseKit/PromiseKit.h>


@implementation DLSServiceLayer

- (PMKPromise *)initialize
{
    return [PMKPromise promiseWithValue:@YES];
}

@end
