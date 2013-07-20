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
 @discussion This class implements the method that generates an Authorization header with Hawk protocol.
 Also provides the method for generate a nonce and a method for generate a timestamp in seconds.
 All methods are class methods, so don't needed to create a HawkClient object for use it.
 @see https://github.com/hueniverse/hawk
 */
@interface HawkClient : NSObject

/*!
 @discussion This method generates an HTTP Authorization header with Hawk protocol. Is possible to generate a header with  validation.
 @param url Request url.
 @param method Type of HTTP method.
 @param timestamp Timestamp in seconds.
 @param nonce Random string.
 @param credentials Hawk credentials object.
 @param ext Some extra string.
 @param payload Request body.
 @param payloadValidation indicates if the header is created with payload validation.
 @return The Authorization header with Hawk protocol.
 */
+ (NSString *)generateAuthorizationHeader:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials ext:(NSString *)ext payload:(NSString *)payload payloadValidation:(BOOL)payloadValidation;

/*!
 @discussion This method returns a timestamp in seconds from UTC time.
 @return The timestamp in seconds.
 */
+ (NSString *)getTimestamp;

/*!
 @discussion This method generates and returns a random string (nonce).
 @return The random nonce.
 */
+ (NSString *)generateNonce;

@end