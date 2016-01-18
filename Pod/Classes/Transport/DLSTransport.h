//
//  DLSTransport.h
//  south-worcestershire
//
//  Created by Alex Rudyak on 11/30/15.
//  Copyright © 2015 Digital Life Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@protocol DLSTransport <NSObject>

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

- (void)setupBasicAuthWithUsername:(NSString *)username password:(NSString *)password;
- (void)updateMediumPathIdentifiers:(NSDictionary *)updatedIdentifiers;
- (void)appendPathForOneRequest:(NSString *)temporalPath;

- (PMKPromise *)fetchAllWithParams:(NSDictionary *)parameters;
- (PMKPromise *)fetchWithId:(id)entityIdentifier;
- (PMKPromise *)create:(NSDictionary *)entity;
- (PMKPromise *)update:(NSDictionary *)entity id:(id)entityIdentifier;
- (PMKPromise *)patch:(NSDictionary *)entity id:(id)entityIdentifier;
- (PMKPromise *)removeWithId:(id)entityIdentifier;

@end
