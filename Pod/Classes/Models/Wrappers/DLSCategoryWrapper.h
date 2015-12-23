//
//  DLSCategoryWrapper.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSCategoryObject;


@interface DLSCategoryWrapper : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *organisationId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *desc;

- (instancetype)initWithCategory:(DLSCategoryObject *)object;

+ (instancetype)categoryWithObject:(DLSCategoryObject *)object;

@end
