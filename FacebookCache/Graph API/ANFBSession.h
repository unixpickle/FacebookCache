//
//  ANFBSession.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+HTTPParams.h"
#import "ANFBOAuthInfo.h"
#import "ANFBResponse.h"
#import "ANFBSessionTicket.h"

typedef void (^ANFBSessionFetchCallback)(ANFBResponse * response, NSError * error);

@interface ANFBSession : NSObject {
    ANFBOAuthInfo * oauthInfo;
    NSMutableArray * activeTickets;
}

- (id)initWithOAuthInfo:(ANFBOAuthInfo *)info;

/**
 * Sends a request, supplying the OAuth token.
 *
 * @param request The request to send. This does not need to contain
 * any information about the session's OAuth token; it will be added.
 *
 * @param error On failure, this value will be set to a more detailed error.
 *
 * @return ANFBResponse A response object upon success, or nil on error.
 * 
 */
- (ANFBResponse *)sendRequestSynchronously:(NSURLRequest *)request error:(NSError **)errorOut;

/**
 * Sends a request, supplying the OAuth token and calling back when the request is complete.
 *
 * @param request The request to send. This does not need to contain
 * any information about the session's OAuth token; it will be added.
 *
 * @param error On failure, this value will be set to a more detailed error.
 *
 * @return A unique ticket which can later be used to cancel this request.
 *
 */
- (ANFBSessionTicket *)sendRequestAsynchronously:(NSURLRequest *)request callback:(ANFBSessionFetchCallback)callback;

/**
 * Cancels an active ticket.
 *
 * @return YES unless the ticket is not active, yielding a result of NO.
 *
 */
- (BOOL)cancelTicket:(ANFBSessionTicket *)ticket;

@end
