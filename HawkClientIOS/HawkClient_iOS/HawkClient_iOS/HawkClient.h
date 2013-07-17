//
//  HawkClient_iOS.h
//  HawkClient_iOS
//
//  Created by Ricardo Sousa on 6/29/13.
//  Copyright (c) 2013 ricardosousa1989. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "HawkCredentials.h"
#import "MF_Base64Additions.h"

#define TIME_FORMAT @"yyyy-MM-dd HH:mm:ss"

/*!
 @class HawkClient
 @discussion This class implements the method @link generateAuthorizationHeader that generates an Authorization header with Hawk protocol. Also provides the method for generate a nonce and a method for generate a timestamp in seconds. All methods are class methods, so don't needed to create a HawkClient object for use it.
 @see https://github.com/hueniverse/hawk
 */
@interface HawkClient : NSObject

/*!
 @function generateAuthorizationHeader
 @param url Request url.
 @param method Type of HTTP method.
 @param timestamp Timestamp in seconds.
 @param nonce Random string.
 @param credentials Hawk credentials object.
 @param ext Some extra string.
 @param payload Request body.
 @return The Authorization header with Hawk protocol.
 @param payloadValidation indicates if the header is created with payload validation.
 @discussion This function generates an HTTP Authorization header with Hawk protocol. Is possible to generate a header with payload validation.
 */
+ (NSString *)generateAuthorizationHeader:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials ext:(NSString *)ext payload:(NSString *)payload payloadValidation:(BOOL)payloadValidation;

/*!
 @function getTimestamp
 @return The timestamp in seconds.
 @discussion This function returns a timestamp in seconds from UTC time.
 */
+ (NSString *)getTimestamp;

/*!
 @function generateNonce
 @return The random nonce.
 @discussion This function generates and returns a random string (nonce).
 */
+ (NSString *)generateNonce;

@end