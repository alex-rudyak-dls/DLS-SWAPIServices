//
//  DLSAuthCredentials.h
//  Pods
//
//  Created by Alex Rudyak on 3/25/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSAuthCredentials : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithCompletion:(nullable void (^)(DLSAuthCredentials *credentials))completion;

@end

NS_ASSUME_NONNULL_END
