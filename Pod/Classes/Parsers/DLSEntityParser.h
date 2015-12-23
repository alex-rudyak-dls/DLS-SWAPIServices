//
//  DLSEntityParser.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/1/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSEntityParser <NSObject>

- (NSArray *)parseResponse:(id)responseObject;

@end
