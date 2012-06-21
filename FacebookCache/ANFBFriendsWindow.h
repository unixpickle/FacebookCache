//
//  ANFBFriendsWindow.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANFBFriends.h"
#import "ANFBFriendWindow.h"

@interface ANFBFriendsWindow : NSWindow <ANFBChainedDataDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    ANFBSession * session;
    ANFBFriends * friends;
    NSTableView * friendsTable;
    NSProgressIndicator * progressIndicator;
}

- (id)initWithSession:(ANFBSession *)aSession;
- (void)createFriendsTable;

- (void)tableDoubleClicked:(id)sender;

@end
