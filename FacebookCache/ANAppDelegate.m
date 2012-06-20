//
//  ANAppDelegate.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANAppDelegate.h"

@implementation ANAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    authWindow = [[ANFBAuthWindow alloc] initWithScreen:[NSScreen mainScreen]];
    [authWindow makeKeyAndOrderFront:self];
    [authWindow setDelegate:self];
}

- (void)authWindow:(ANFBAuthWindow *)aWindow didAuthenticate:(ANFBOAuthInfo *)info {
    NSLog(@"Got OAuth info: %@", info);
    [authWindow orderOut:self];
    authWindow = nil;
}

@end
