//
//  NSString+DLSEntityParsing.m
//  south-worcestershire
//
//  Created by Alex Rudyak on 12/12/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import "NSString+DLSEntityParsing.h"


@implementation NSString (DLSEntityParsing)

- (BOOL)dls_containsEntities
{
    return [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]].location != NSNotFound;
}

@end
