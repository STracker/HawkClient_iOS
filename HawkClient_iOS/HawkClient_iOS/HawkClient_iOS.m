//
//  HawkClient_iOS.m
//  HawkClient_iOS
//
//  Created by Ricardo Sousa on 6/29/13.
//  Copyright (c) 2013 ricardosousa1989. All rights reserved.
//

#import "HawkClient_iOS.h"

@implementation HawkClient_iOS

- (NSString *)generateMACWithUrl:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials payload:(NSString *)payload ext:(NSString *)ext
{
    if (url == nil || method == nil || timestamp == nil || nonce == nil || credentials == nil)
        [NSException raise:@"Invalid arguments." format:@"url, method, timestamp, nonce and credentials are required!"];
    
    
    // Preparing the variables.
    NSString *header = @"hawk.1.header";
    method = [method uppercaseString];
    NSString *query = (url.query == nil) ? @"" : url.query;
    NSString *uri = [NSString stringWithFormat:@"%@%@", url.path, query];
    NSString *host = url.host;
    NSString *port = [url.port stringValue];
    payload = (payload == nil) ? @"" : payload;
    ext = (ext == nil) ? @"" : ext;
    
    // Creating the normalized string.
    NSString *normalized = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n", header, timestamp, nonce, method, uri, host, port, payload, ext];
    
    // Generate HMAC using SHA256 algorithm.
    const char *cKey = [credentials.key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cNormalized = [normalized cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cNormalized, strlen(cNormalized), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    // Get base64-encoded result.
    NSString *hash = [HMAC base64String];
    
    return hash;
}

@end