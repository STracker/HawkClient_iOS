//
//  HawkClient_iOS.m
//  HawkClient_iOS
//
//  Created by Ricardo Sousa on 6/29/13.
//  Copyright (c) 2013 ricardosousa1989. All rights reserved.
//

#import "HawkClient.h"

@implementation HawkClient

/*!
 @function generateMAC
 @param normalized The normalized string.
 @param credentials The user Hawk credentials.
 @return The generated MAC in base64-encoded.
 @discussion This is a private auxiliary function for generate a MAC using SHA256 algorithm.
 */
+ (NSString *)generateMAC:(NSString *)normalized credentials:(HawkCredentials *)credentials
{
    const char *cKey = [credentials.key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cNormalized = [normalized cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cNormalized, strlen(cNormalized), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [HMAC base64String];
}

/*!
 @function generateNormalizedString
 @param url Request url.
 @param method Type of HTTP method.
 @param timestamp Timestamp in seconds.
 @param nonce Random string.
 @param credentials Hawk credentials object.
 @param payload Request body.
 @param ext Some extra string.
 @return The normalized string according to Hawk protocol.
 @discussion This function generates a normalized string. In this function the port number is not used because of load balancing performed from some hosts.
 */
+ (NSString *)generateNormalizedString:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials payload:(NSString *)payload ext:(NSString *)ext
{
    // Preparing the variables.
    NSString *header = @"hawk.1.header";
    method = [method uppercaseString];
    NSString *query = (url.query == nil) ? @"" : url.query;
    NSString *uri = [NSString stringWithFormat:@"%@%@", url.path, query];
    NSString *host = url.host;
    
    // Creating the normalized string.
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n", header, timestamp, nonce, method, uri, host, payload, ext];
}

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
+ (NSString *)generateAuthorizationHeader:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials ext:(NSString *)ext payload:(NSString *)payload payloadValidation:(BOOL)payloadValidation
{
    if (url == nil || method == nil || timestamp == nil || nonce == nil || credentials == nil)
        [NSException raise:@"Invalid arguments." format:@"url, method, timestamp, nonce and credentials are required!"];
    
    // Prepare some variables that may be null.
    payload = (payload == nil) ? @"" : payload;
    ext = (ext == nil) ? @"" : ext;
    
    // Generate the payload hash if the request is with payload validation.
    if (payloadValidation)
        payload = [HawkClient generateMAC:payload credentials:credentials];
    
    // Generate the MAC.
    NSString *MAC = [self generateMAC:[self generateNormalizedString:url method:method timestamp:timestamp nonce:nonce credentials:credentials payload:payload ext:ext] credentials:credentials];
    
    return payloadValidation ?
    [NSString stringWithFormat:@"Hawk id=\"%@\", ts=\"%@\", nonce=\"%@\", hash=\"%@\", ext=\"%@\", mac=\"%@\"", credentials.identifier, timestamp, nonce, payload, ext, MAC] :
    [NSString stringWithFormat:@"Hawk id=\"%@\", ts=\"%@\", nonce=\"%@\", ext=\"%@\", mac=\"%@\"", credentials.identifier, timestamp, nonce, ext, MAC];
}

/*!
 @function getTimestamp
 @return The timestamp in seconds.
 @discussion This function returns a timestamp in seconds from UTC time.
 */
+ (NSString *)getTimestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setDateFormat:TIME_FORMAT];
    [dateFormatter setTimeZone:timeZone];
    NSDate * date = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    NSTimeInterval interval = [date timeIntervalSince1970];
    long timestamp = interval;
    return [NSString stringWithFormat:@"%ld", timestamp];
}

/*!
 @function generateNonce
 @return The random nonce.
 @discussion This function generates and returns a random string (nonce).
 */
+ (NSString *)generateNonce
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *nonce = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return nonce;
}

@end