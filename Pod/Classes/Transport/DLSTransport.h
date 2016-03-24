//
//  DLSTransport.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 11/30/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PMKPromise;
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

- (BFTask *)bft_fetchAllWithParams:(nullable NSDictionary<NSString *, id> *)parameters;

- (BFTask *)bft_fetchWithId:(id)entityIdentifier;

- (BFTask *)bft_create:(NSDictionary *)entity;

- (BFTask *)bft_update:(NSDictionary *)entity id:(id)entityIdentifier;

- (BFTask *)bft_patch:(NSDictionary *)entity id:(id)entityIdentifier;

- (BFTask *)bft_removeWithId:(id)entityIdentifier;

@end

NS_ASSUME_NONNULL_END
