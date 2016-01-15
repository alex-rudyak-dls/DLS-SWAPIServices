//
//  DLSApplicationContentObject.m
//  Pods
//
//  Created by Alex Rudyak on 1/14/16.
//
//

#import "DLSApplicationContentObject.h"


@implementation DLSApplicationContentObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"version"]];
    }];
}

+ (NSString *)primaryKey
{
    return @"version";
}

- (NSDictionary *)contentDictionary
{
    return [NSJSONSerialization JSONObjectWithData:self.content options:NSJSONReadingMutableLeaves error:nil];
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
