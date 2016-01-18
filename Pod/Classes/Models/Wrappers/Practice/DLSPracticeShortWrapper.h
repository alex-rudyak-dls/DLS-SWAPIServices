//
//  DLSPracticeShortWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLSPracticeWrapper.h"

@class DLSPracticeObject;


@interface DLSPracticeShortWrapper : NSObject <DLSPracticeWrapper>

@property (nonatomic, readonly) NSString *practiceId;
@property (nonatomic, readonly) NSString *handleId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly, getter=isPartOfHub) BOOL partOfHub;

@end
