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

@interface HawkClient_iOS : NSObject

- (NSString *)generateAuthorizationHeader:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials payload:(NSString *)payload ext:(NSString *)ext;

- (NSString *)generateAuthorizationHeaderWithPayloadValidation:(NSURL *)url method:(NSString *)method timestamp:(NSString *)timestamp nonce:(NSString *)nonce credentials:(HawkCredentials *)credentials payload:(NSString *)payload ext:(NSString *)ext contentType:(NSString *)contentType;

@end
