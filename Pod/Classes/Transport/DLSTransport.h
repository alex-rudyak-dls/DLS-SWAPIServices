//
//  DLSTransport.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 11/30/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BFTask;

@protocol DLSTransport

@required

/**
 *  Default: nil
 */
@property (nonatomic, strong) NSString *authorizationHeader;

/**
 *  Contains medium identifiers which are inside provided path. For example:
 *  `/path/{fileId}/internalFolder`, where `{fileId}` is medium identifier;
 *  In that dictionary you need contain in the next format: "fileId": "value".
 */
@property (nonatomic, strong) NSDictionary *mediumPathIdentifiers;

#pragma mark - Presetup methods

- (void)setupBasicAuthWithUsername:(NSString *)username password:(NSString *)password;

- (void)updateMediumPathIdentifiers:(NSDictionary *)updatedIdentifiers;

- (void)appendPathForOneRequest:(NSString *)temporalPath;

#pragma mark - Public

- (BFTask *)fetchAllWithParams:(nullable NSDictionary<NSString *, id> *)parameters;

- (BFTask *)fetchWithId:(id)entityIdentifier;

- (BFTask *)create:(NSDictionary *)entity;

- (BFTask *)update:(NSDictionary *)entity id:(id)entityIdentifier;

- (BFTask *)patch:(NSDictionary *)entity id:(id)entityIdentifier;

- (BFTask *)removeWithId:(id)entityIdentifier;

@end

NS_ASSUME_NONNULL_END
