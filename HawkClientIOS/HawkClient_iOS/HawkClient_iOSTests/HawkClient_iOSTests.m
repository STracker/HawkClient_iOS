//
//  HawkClient_iOSTests.m
//  HawkClient_iOSTests
//
//  Created by Ricardo Sousa on 6/29/13.
//  Copyright (c) 2013 ricardosousa1989. All rights reserved.
//

#import "HawkClient_iOSTests.h"

@implementation HawkClient_iOSTests

- (void)testGenerateAuthorizationHeader
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"100000004098766";

    NSString *nonce = @"09B8AFD6-B784-4981-ADD5-BEFF55C9E60D";
    NSString *timestamp = @"1374079191";
    NSString *method = @"GET";
    NSURL *url = [NSURL URLWithString:@"http://example.com/test/100005742427425"];
    
    NSString *header = [HawkClient generateAuthorizationHeader:url method:method timestamp:timestamp nonce:nonce credentials:credentials ext:nil payload:nil payloadValidation:NO];
    
    STAssertEqualObjects(header, @"Hawk id=\"100000004098766\", ts=\"1374079191\", nonce=\"09B8AFD6-B784-4981-ADD5-BEFF55C9E60D\", ext=\"\", mac=\"gzslhz6MERFF0ODS2BMw7LCSrjB/wa7W765M4epPmkQ=\"", @"Generated Authorization header");
}

- (NSString *)urlencode:(NSString *)str {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (void)testeGenerateAuthorizationHeaderWithPayload
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"100000004098766";
    
    NSString *nonce = @"09B8AFD6-B784-4981-ADD5-BEFF55C9E60D";
    NSString *timestamp = @"1374079796";
    NSString *method = @"POST";
    NSURL *url = [NSURL URLWithString:@"http://example.com/test/"];
    NSString *payload = @"Some payload.";
    
    NSString *header = [HawkClient generateAuthorizationHeader:url method:method timestamp:timestamp nonce:nonce credentials:credentials ext:nil payload:payload payloadValidation:YES];
    
    STAssertEqualObjects(header, @"Hawk id=\"100000004098766\", ts=\"1374079796\", nonce=\"09B8AFD6-B784-4981-ADD5-BEFF55C9E60D\", hash=\"BtJQcST2BgfVHsmtXOopFzX2dJdZRwKMeuaj7nCcaQg=\", ext=\"\", mac=\"Sj78StVH2zGfmNbPEWZtie/nMyxGf2VCEO5oWvcBoZ8=\"", @"Generated Authorization header");
}

- (void)testException
{
    // Create the credentials
    HawkCredentials *credentials = [[HawkCredentials alloc] init];
    credentials.key = @"werxhqb98rpaxn39848xrunpaw3489ruxnpa98w4rxn";
    credentials.identifier = @"dh37fgj492je";
    
    NSURL *url = [NSURL URLWithString:@"http://example.com/test/1?b=1&a=2"];

    STAssertThrows([HawkClient generateAuthorizationHeader:url method:nil timestamp:nil nonce:nil credentials:credentials ext:nil payload:nil payloadValidation:NO], @"Expected Exception because some fields are nil.");
}

@end
