//
//  DLSPracticeWrapperFactory.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticeWrapperFactory.h"
#import "DLSPracticeShortWrapper.h"


@implementation DLSPracticeWrapperAbstractFactory

- (id<DLSPracticeWrapper>)practiceWithObject:(id)object
{
    return [DLSPracticeWrapper practiceWithObject:object];
}

@end


@implementation DLSPracticeShortWrapperAbstractFactory

- (id<DLSPracticeWrapper>)practiceWithObject:(DLSPracticeObject *)object
{
    return [DLSPracticeShortWrapper practiceWithObject:object];
}

@end
