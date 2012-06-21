//
//  ANFBSessionTicket.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBSessionTicket.h"

@implementation ANFBSessionTicket

@synthesize ticketNumber;

- (id)initWithTicketNumber:(NSInteger)aNumber {
    if ((self = [super init])) {
        ticketNumber = aNumber;
    }
    return self;
}

- (id)initWithUniqueTicket {
    static NSInteger ticket = 0;
    return [self initWithTicketNumber:ticket++];
}

- (BOOL)isEqualToTicket:(ANFBSessionTicket *)ticket {
    return (ticketNumber == ticket.ticketNumber);
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) return NO;
    return [self isEqualToTicket:object];
}

@end
