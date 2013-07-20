//
//  HawkCredentials.h
//  HawkClient_iOS
//
//  Created by Ricardo Sousa on 6/29/13.
//  Copyright (c) 2013 ricardosousa1989. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @discussion This class implements the object HawkCredentials,
 that includes the user identifier and the shared key between the
 server and the iOS client.
 @see https://github.com/hueniverse/hawk
 */
@interface HawkCredentials : NSObject

@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *key;

@end