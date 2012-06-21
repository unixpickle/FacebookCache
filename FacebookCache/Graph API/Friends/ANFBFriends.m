//
//  ANFBFriends.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBFriends.h"

@implementation ANFBFriends

+ (NSString *)connectionPathFormat {
    return kANFBFriendsGraphURL;
}

+ (id)chainedObjectForDataEntry:(NSDictionary *)anEntry {
    return [[ANFBPerson alloc] initWithUserObject:anEntry];
}

- (NSArray *)friends {
    return [self objectChain];
}

@end
