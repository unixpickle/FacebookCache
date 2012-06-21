//
//  ANFBFriendsWindow.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBFriendsWindow.h"

@implementation ANFBFriendsWindow

- (id)initWithSession:(ANFBSession *)aSession {
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    NSRect windowFrame = NSMakeRect(0, 0, 500, 400);
    windowFrame.origin.x = (screenFrame.size.width - windowFrame.size.width) / 2;
    windowFrame.origin.y = (screenFrame.size.height - windowFrame.size.height) / 2;
    if ((self = [super initWithContentRect:windowFrame
                                 styleMask:(NSTitledWindowMask | NSClosableWindowMask)
                                   backing:NSBackingStoreBuffered
                                     defer:NO])) {
        session = aSession;
        // create initial progress indicator
        progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect((windowFrame.size.width - 8) / 2,
                                                                                  (windowFrame.size.height - 8) / 2,
                                                                                  16, 16)];
        [progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
        [progressIndicator startAnimation:self];
        [self.contentView addSubview:progressIndicator];
        // create friends
        friends = [[ANFBFriends alloc] initWithSession:session facebookID:@"me"];
        [friends setDelegate:self];
        [friends beginFetching];
    }
    return self;
}

- (void)createFriendsTable {
    NSRect bounds = [[self contentView] bounds];
    NSScrollView * tableScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10,
                                                                                    bounds.size.width - 20,
                                                                                    bounds.size.height - 20)];
    
    friendsTable = [[NSTableView alloc] initWithFrame:tableScrollView.bounds];
    [friendsTable setDelegate:self];
    [friendsTable setDataSource:self];
    
    NSTableColumn * friendColumn = [[NSTableColumn alloc] initWithIdentifier:@"Friend"];
    [[friendColumn headerCell] setStringValue:@"Name"];
    [friendColumn setWidth:300];
    [friendColumn setEditable:NO];
    [friendsTable addTableColumn:friendColumn];
    
    [tableScrollView setDocumentView:friendsTable];
    [tableScrollView setBorderType:NSBezelBorder];
    [tableScrollView setHasVerticalScroller:YES];
    [tableScrollView setHasHorizontalScroller:YES];
    [tableScrollView setAutohidesScrollers:NO];
    [tableScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[self contentView] addSubview:tableScrollView];
}

#pragma mark - Friends Delegate -

- (void)chainedData:(ANFBChainedData *)chain failedWithError:(NSError *)anError {
    NSLog(@"Chain error: %@", anError);
}

- (void)chainedDataFetched:(ANFBChainedData *)chain {
    [progressIndicator stopAnimation:self];
    [progressIndicator removeFromSuperview];
    [self createFriendsTable];
}

#pragma mark - Friends Table -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[friends friends] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ANFBPerson * person = [[friends friends] objectAtIndex:row];
    return [person name];
}

@end
