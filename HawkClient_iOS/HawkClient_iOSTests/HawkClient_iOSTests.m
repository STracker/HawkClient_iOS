//
//  HawkClient_iOSTests.m
//  HawkClient_iOSTests
//
//  Created by Ricardo Sousa on 6/29/13.
//  Copyright (c) 2013 ricardosousa1989. All rights reserved.
//

#import "HawkClient_iOSTests.h"

@implementation HawkClient_iOSTests

- (void)setUp
{
    [super setUp];
    
    client = [[HawkClient_iOS alloc] init];
}

- (void)tearDown
{
    client = nil;
    [super tearDown];
}

- (void)testGenerateMAC
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"100005742427426";

    NSString *nonce = @"Ucbxsg";
    NSString *timestamp = @"1372542";
    NSString *method = @"GET";
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:4443/api/user"];
    
    NSString *mac = [client generateMACWithUrl:url method:method timestamp:timestamp nonce:nonce credentials:credentials payload:nil ext:nil];

    STAssertEqualObjects(mac, @"CAxl/vEGN4nixHJx++Qehop7We2/GWsMCG0pDun7BA8=", @"Generated MAC");
}

- (void)testException
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"100005742427426";
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:4443/api/user"];

    STAssertThrows([client generateMACWithUrl:url method:nil timestamp:nil nonce:nil credentials:credentials payload:nil ext:nil], @"Expected Exception because some fields are nil.");
}

@end
