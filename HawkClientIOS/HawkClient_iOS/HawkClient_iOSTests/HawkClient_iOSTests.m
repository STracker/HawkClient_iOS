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

- (void)testGenerateAuthorizationHeader
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"100005742427426";

    NSString *nonce = @"Ucbxsg";
    NSString *timestamp = @"1372542";
    NSString *method = @"GET";
    NSURL *url = [NSURL URLWithString:@"http://localhost:4443/api/user"];
    
    NSString *header = [client generateAuthorizationHeader:url method:method timestamp:timestamp nonce:nonce credentials:credentials payload:nil ext:nil];
    
    STAssertEqualObjects(header, @"Hawk id=\"100005742427426\", ts=\"1372542\", nonce=\"Ucbxsg\", ext=\"\", mac=\"CAxl/vEGN4nixHJx++Qehop7We2/GWsMCG0pDun7BA8=\"", @"Generated Authorization header");
}

- (void)testeGenerateAuthorizationHeaderWithPayload
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"100005742427426";
    
    NSString *nonce = @"Ucbxsg";
    NSString *timestamp = @"1372542";
    NSString *method = @"GET";
    NSURL *url = [NSURL URLWithString:@"http://localhost:4443/api/user"];
    NSString *payload = @"some payload.";
    NSString *contentType = @"text/plain";
    
    NSString *header = [client generateAuthorizationHeaderWithPayloadValidation:url method:method timestamp:timestamp nonce:nonce credentials:credentials payload:payload ext:nil contentType:contentType];
    
    STAssertEqualObjects(header, @"Hawk id=\"100005742427426\", ts=\"1372542\", nonce=\"Ucbxsg\", hash=\"G5k81X6y/DXRujfQBZKOWFqWyGvgu7TJp/vHUFxp1AI=\", ext=\"\", mac=\"oybUvgoMPIDGt38KVyu2t9/1hEtrMShHDdcKCwt/aKc=\"", @"Generated Authorization header");
}

- (void)testException
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"dh37fgj492je";
    
    NSURL *url = [NSURL URLWithString:@"http://example.com/resource/1?b=1&a=2"];

    STAssertThrows([client generateAuthorizationHeader:url method:nil timestamp:nil nonce:nil credentials:credentials payload:nil ext:nil], @"Expected Exception because some fields are nil.");
    
    STAssertThrows([client generateAuthorizationHeaderWithPayloadValidation:url method:nil timestamp:nil nonce:nil credentials:credentials payload:nil ext:nil contentType:nil], @"Expected Exception because some fields are nil.");
}

@end
