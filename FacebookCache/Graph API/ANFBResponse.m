//
//  ANFBResponse.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBResponse.h"

@implementation ANFBResponse

@synthesize request;
@synthesize response;
@synthesize responseData;
@synthesize jsonObject;

- (id)initWithRequest:(NSURLRequest *)aRequest response:(NSURLResponse *)theResponse data:(NSData *)theData {
    if ((self = [super init])) {
        request = aRequest;
        response = theResponse;
        responseData = theData;
        jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    }
    return self;
}

#pragma mark - Processing Responses -

- (NSDictionary *)responseDictionary {
    if (![jsonObject isKindOfClass:[NSDictionary class]]) return nil;
    return (NSDictionary *)jsonObject;
}

- (NSURL *)nextPage {
    NSDictionary * paging = [[self responseDictionary] objectForKey:@"paging"];
    if (!paging) return nil;
    NSString * nextString = [paging objectForKey:@"next"];
    if (!nextString) return nil;
    return [NSURL URLWithString:nextString];
}

- (NSArray *)responseDataArray {
    id obj = [[self responseDictionary] objectForKey:@"data"];
    if (![obj isKindOfClass:[NSArray class]]) return nil;
    return obj;
}

#pragma mark Errors

- (BOOL)isErrorMessage {
    NSDictionary * dictionary = [self responseDictionary];
    if (!dictionary) return NO;
    if ([dictionary objectForKey:@"error"]) return YES;
    return NO;
}

- (NSError *)responseError {
    NSDictionary * dictionary = [self responseDictionary];
    NSDictionary * error = [dictionary objectForKey:@"error"];
    if (!error) return nil;
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    NSInteger errorNumber = 0;
    NSString * errorDomain = @"GraphAPI";
    if ([error objectForKey:@"message"]) {
        [userInfo setObject:[error objectForKey:@"message"] forKey:NSLocalizedDescriptionKey];
    }
    if ([error objectForKey:@"error_subcode"]) {
        [userInfo setObject:[error objectForKey:@"error_subcode"] forKey:@"subcode"];
    }
    if ([error objectForKey:@"code"]) {
        errorNumber = [[error objectForKey:@"code"] integerValue];
    }
    if ([error objectForKey:@"type"]) {
        errorDomain = [error objectForKey:@"type"];
    }
    return [NSError errorWithDomain:errorDomain code:errorNumber userInfo:userInfo];
}

@end
