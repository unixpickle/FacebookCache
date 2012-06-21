//
//  ANFBFriends.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBChainedObjects.h"
#import "ANFBPerson.h"

#define kANFBFriendsGraphURL @"https://graph.facebook.com/%@/friends"

@interface ANFBFriends : ANFBChainedObjects

- (NSArray *)friends;

@end
