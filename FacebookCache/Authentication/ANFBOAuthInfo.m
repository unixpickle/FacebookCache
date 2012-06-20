//
//  ANFBOAuthInfo.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBOAuthInfo.h"

@implementation ANFBOAuthInfo

@synthesize expiresIn;
@synthesize accessToken;
@synthesize obtainedDate;

- (id)initWithResponseURL:(NSURL *)theURL {
    if ((self = [super init])) {
        NSString * infoString = [theURL fragment];
        if (!infoString) return nil;
        
        NSArray * parameters = [infoString componentsSeparatedByString:@"&"];
        for (NSString * parameter in parameters) {
            NSArray * parts = [parameter componentsSeparatedByString:@"="];
            if ([parts count] != 2) continue;
            NSString * key = [parts objectAtIndex:0];
            NSString * value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([key isEqualToString:@"access_token"]) {
                accessToken = value;
            } else if ([key isEqualToString:@"expires_in"]) {
                expiresIn = [value doubleValue];
            }
        }
        
        if (!accessToken) return nil;
        obtainedDate = [NSDate date];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, {accessToken: %@,\n\t\texpires: %lf>",
            NSStringFromClass([self class]), self, accessToken, expiresIn];
}

@end
