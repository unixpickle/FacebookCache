//
//  ANAppDelegate.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANFBAuthWindow.h"
#import "ANFBFriendsWindow.h"

@interface ANAppDelegate : NSObject <NSApplicationDelegate, ANFBAuthWindowDelegate> {
    ANFBAuthWindow * authWindow;
    ANFBFriendsWindow * friendsWindow;
}

@end
