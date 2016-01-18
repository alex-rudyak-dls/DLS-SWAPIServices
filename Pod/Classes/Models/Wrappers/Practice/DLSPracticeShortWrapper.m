//
//  DLSPracticeShortWrapper.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/13/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "DLSPracticeShortWrapper.h"
#import "DLSPracticeObject.h"


@implementation DLSPracticeShortWrapper

+ (instancetype)practiceWithObject:(DLSPracticeObject *)object
{
    return [[self alloc] initWithPractice:object];
}

- (instancetype)initWithPractice:(DLSPracticeObject *)object
{
    self = [self init];
    if (self) {
        _practiceId = object.id;
        _handleId = object.handleId;
        _name = object.name;
        _imageURL = [NSURL URLWithString:object.imageURL];
        _partOfHub = object.partOfHub;
    }
    return self;
}

@end
