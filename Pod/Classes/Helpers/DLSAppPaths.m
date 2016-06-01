//
//  DLSAppPaths.m
//  Pods
//
//  Created by Alex Rudyak on 12/23/15.
//
//

#import "DLSAppPaths.h"

NS_ASSUME_NONNULL_BEGIN

NSString *DLSUserDirectory()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

NSString *DLSUserDirectoryWithFilename(NSString *filename)
{
    return [DLSUserDirectory() stringByAppendingPathComponent:filename];
}

NSInteger DLSRealmSchemeVersion = 1;

NS_ASSUME_NONNULL_END
