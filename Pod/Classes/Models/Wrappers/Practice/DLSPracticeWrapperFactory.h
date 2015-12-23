//
//  DLSPracticeWrapperFactory.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSPracticeObject;
@protocol DLSPracticeWrapper;

@protocol DLSPracticeWrapperFactory <NSObject>

- (id<DLSPracticeWrapper>)practiceWithObject:(DLSPracticeObject *)object;

@end


@interface DLSPracticeWrapperAbstractFactory : NSObject <DLSPracticeWrapperFactory>

@end


@interface DLSPracticeShortWrapperAbstractFactory : NSObject <DLSPracticeWrapperFactory>

@end
