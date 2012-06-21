//
//  ANFBSessionTicket.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANFBSessionTicket : NSObject {
    NSInteger ticketNumber;
}

@property (readonly) NSInteger ticketNumber;

- (id)initWithTicketNumber:(NSInteger)aNumber;
- (id)initWithUniqueTicket;

- (BOOL)isEqualToTicket:(ANFBSessionTicket *)ticket;
- (BOOL)isEqual:(id)object;

@end
