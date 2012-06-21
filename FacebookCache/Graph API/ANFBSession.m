//
//  ANFBSession.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBSession.h"

@interface ANFBSession (Private)

- (NSURLRequest *)authorizedRequest:(NSURLRequest *)original;

@end

@implementation ANFBSession

- (id)initWithOAuthInfo:(ANFBOAuthInfo *)info {
    if ((self = [super init])) {
        oauthInfo = info;
        activeTickets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (ANFBResponse *)sendRequestSynchronously:(NSURLRequest *)request error:(NSError **)errorOut {
    NSURLRequest * authedRequest = [self authorizedRequest:request];
    NSURLResponse * urlResponse = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:authedRequest returningResponse:&urlResponse error:errorOut];
    if (!data) return nil;
    return [[ANFBResponse alloc] initWithRequest:authedRequest response:urlResponse data:data];
}

- (ANFBSessionTicket *)sendRequestAsynchronously:(NSURLRequest *)request callback:(ANFBSessionFetchCallback)callback {
    ANFBSessionTicket * ticket = [[ANFBSessionTicket alloc] initWithUniqueTicket];
    @synchronized (activeTickets) {
        [activeTickets addObject:ticket];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_current_queue();
    dispatch_async(queue, ^{
        NSError * error = nil;
        ANFBResponse * response = [self sendRequestSynchronously:request error:&error];
        BOOL isActive = YES;
        @synchronized (activeTickets) {
            isActive = [activeTickets containsObject:ticket];
            if (isActive) [activeTickets removeObject:ticket];
        }
        if (isActive) {
            dispatch_async(mainQueue, ^{
                callback(response, error);
            });
        }
    });
    
    return ticket;
}

- (BOOL)cancelTicket:(ANFBSessionTicket *)ticket {
    @synchronized (activeTickets) {
        if ([activeTickets containsObject:ticket]) {
            [activeTickets removeObject:ticket];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Private -

- (NSURLRequest *)authorizedRequest:(NSURLRequest *)original {
    NSMutableURLRequest * mutRequest = [original mutableCopy];
    NSURL * requestURL = [mutRequest URL];
    
    // append access token to URL
    NSString * urlString = [requestURL absoluteString];
    NSDictionary * params = [NSDictionary dictionaryFromURLParameters:requestURL];
    if (![params objectForKey:@"access_token"]) {
        NSString * accessToken = [NSString stringWithFormat:@"access_token=%@", [oauthInfo accessToken]];
        if ([params count] == 0) {
            urlString = [urlString stringByAppendingFormat:@"?%@", accessToken];
        } else {
            urlString = [urlString stringByAppendingFormat:@"&%@", accessToken];
        }
    }
    NSURL * newURL = [NSURL URLWithString:urlString];
    [mutRequest setURL:newURL];
    
    return mutRequest;
}

@end
