//
//  ANFBFriendWindow.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBFriendWindow.h"

@interface ANFBFriendWindow (Private)

+ (NSMutableSet *)friendWindows;

@end

@implementation ANFBFriendWindow

+ (NSMutableSet *)friendWindows {
    static NSMutableSet * windows = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windows = [[NSMutableSet alloc] init];
    });
    return windows;
}

#pragma mark - UI -

- (id)initWithSession:(ANFBSession *)theSession friend:(ANFBPerson *)aPerson {
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    NSRect windowFrame = NSMakeRect(0, 0, 400, 400);
    windowFrame.origin.x = (screenFrame.size.width - windowFrame.size.width) / 2;
    windowFrame.origin.y = (screenFrame.size.height - windowFrame.size.height) / 2;
    windowFrame.origin.x += arc4random() * (screenFrame.size.width - windowFrame.size.width) / 2 - 100;
    windowFrame.origin.y += arc4random() * (screenFrame.size.height - windowFrame.size.height) / 2 - 100;
    if (self = [super initWithContentRect:windowFrame
                                styleMask:(NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask)
                                  backing:NSBackingStoreBuffered
                                    defer:NO]) {
        [self setReleasedWhenClosed:NO];
        session = theSession;
        friend = aPerson;
        disabledAlbums = [[NSMutableArray alloc] init];
        self.title = [NSString stringWithFormat:@"%@'s Stuff", [aPerson name]];
        
        // progress indicators
        CGRect photosFrame = NSRectToCGRect([self photosTableFrame]);
        CGRect albumsFrame = NSRectToCGRect([self albumsTableFrame]);
        NSRect photosProgressFrame = NSMakeRect(CGRectGetMidX(photosFrame) - 8,
                                                CGRectGetMidY(photosFrame) - 8,
                                                16, 16);
        NSRect albumsProgressFrame = NSMakeRect(CGRectGetMidX(albumsFrame) - 8,
                                                CGRectGetMidY(albumsFrame) - 8,
                                                16, 16);
        photosProgress = [[NSProgressIndicator alloc] initWithFrame:photosProgressFrame];
        albumsProgress = [[NSProgressIndicator alloc] initWithFrame:albumsProgressFrame];
        [photosProgress setControlSize:NSSmallControlSize];
        [albumsProgress setControlSize:NSSmallControlSize];
        [photosProgress setStyle:NSProgressIndicatorSpinningStyle];
        [albumsProgress setStyle:NSProgressIndicatorSpinningStyle];
        [photosProgress startAnimation:nil];
        [albumsProgress startAnimation:nil];
        
        [self.contentView addSubview:photosProgress];
        [self.contentView addSubview:albumsProgress];
        
        // load photos and albums
        photos = [[ANFBPhotos alloc] initWithSession:session facebookID:[friend userID]];
        albums = [[ANFBAlbums alloc] initWithSession:session facebookID:[friend userID]];
        [photos setDelegate:self];
        [albums setDelegate:self];
        [photos beginFetching];
        [albums beginFetching];
    }
    return self;
}

- (NSRect)photosTableFrame {
    NSRect frame = [[self contentView] bounds];
    return NSMakeRect(10, (frame.size.height - 72) / 2 + 62, frame.size.width - 20, (frame.size.height - 72) / 2);
}

- (NSRect)albumsTableFrame {
    NSRect frame = [[self contentView] bounds];
    return NSMakeRect(10, 52, frame.size.width - 20, (frame.size.height - 72) / 2);
}

- (void)createPhotosTable {
    NSScrollView * tableScrollView = [[NSScrollView alloc] initWithFrame:[self photosTableFrame]];
    
    photosTable = [[NSTableView alloc] initWithFrame:tableScrollView.bounds];
    [photosTable setDelegate:self];
    [photosTable setDataSource:self];
    
    NSTableColumn * photoColumn = [[NSTableColumn alloc] initWithIdentifier:@"PhotoID"];
    [[photoColumn headerCell] setStringValue:@"Photo ID"];
    [photoColumn setWidth:300];
    [photoColumn setEditable:NO];
    [photosTable addTableColumn:photoColumn];
    
    [tableScrollView setDocumentView:photosTable];
    [tableScrollView setBorderType:NSBezelBorder];
    [tableScrollView setHasVerticalScroller:YES];
    [tableScrollView setHasHorizontalScroller:YES];
    [tableScrollView setAutohidesScrollers:NO];
    [tableScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[self contentView] addSubview:tableScrollView];
}

- (void)createAlbumsTable {
    NSScrollView * tableScrollView = [[NSScrollView alloc] initWithFrame:[self albumsTableFrame]];
    
    albumsTable = [[NSTableView alloc] initWithFrame:tableScrollView.bounds];
    [albumsTable setDelegate:self];
    [albumsTable setDataSource:self];
    
    NSTableColumn * checkColumn = [[NSTableColumn alloc] initWithIdentifier:@"Download"];
    [[checkColumn headerCell] setStringValue:@"√"];
    [checkColumn setWidth:20];
    [albumsTable addTableColumn:checkColumn];
    
    NSTableColumn * albumColumn = [[NSTableColumn alloc] initWithIdentifier:@"Name"];
    [[albumColumn headerCell] setStringValue:@"Album Name"];
    [albumColumn setWidth:350];
    [albumColumn setEditable:NO];
    [albumsTable addTableColumn:albumColumn];
    
    [tableScrollView setDocumentView:albumsTable];
    [tableScrollView setBorderType:NSBezelBorder];
    [tableScrollView setHasVerticalScroller:YES];
    [tableScrollView setHasHorizontalScroller:YES];
    [tableScrollView setAutohidesScrollers:NO];
    [tableScrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[self contentView] addSubview:tableScrollView];
}

#pragma mark - Events -

- (void)makeKeyAndOrderFront:(id)sender {
    [super makeKeyAndOrderFront:sender];
    [[[self class] friendWindows] addObject:self];
}

- (void)orderOut:(id)sender {
    [[[self class] friendWindows] removeObject:self];
    if ([photos isLoading]) {
        [photos cancelFetching];
    }
    if ([albums isLoading]) {
        [albums cancelFetching];
    }
    [super orderOut:sender];
}

#pragma mark - Photos & Albums Callback -

- (void)chainedDataFetched:(ANFBChainedData *)chain {
    if (chain == photos) {
        [photosProgress stopAnimation:self];
        [photosProgress removeFromSuperview];
        [self createPhotosTable];
    } else if (chain == albums) {
        [albumsProgress stopAnimation:self];
        [albumsProgress removeFromSuperview];
        [self createAlbumsTable];
    }
}

- (void)chainedData:(ANFBChainedData *)chain failedWithError:(NSError *)anError {
    NSLog(@"%@ error: %@", chain, anError);
}

#pragma mark - Table View -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == photosTable) {
        return [[photos photos] count];
    } else {
        return [[albums albums] count];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == photosTable) {
        return [[[photos photos] objectAtIndex:row] photoID];
    }
    
    // albums table
    ANFBAlbum * album = [[albums albums] objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        return [album name];
    }
    if ([disabledAlbums containsObject:album]) {
        return [NSNumber numberWithBool:NO];
    }
    return [NSNumber numberWithBool:YES];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"Download"]) {
        NSButtonCell * cell = [[NSButtonCell alloc] init];
        [cell setButtonType:NSSwitchButton];
        [cell setTitle:@""];
        return cell;
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView != albumsTable || ![[tableColumn identifier] isEqualToString:@"Download"]) return;
    ANFBAlbum * album = [[albums albums] objectAtIndex:row];
    BOOL setValue = [object boolValue];
    if (setValue && [disabledAlbums containsObject:album]) {
        [disabledAlbums removeObject:album];
    } else if (!setValue && ![disabledAlbums containsObject:album]) {
        [disabledAlbums addObject:album];
    }
}

#pragma mark - Memory -

- (void)dealloc {
    // they can't have weak references because we're an NSWindow
    NSLog(@"Dealloc");
    [photos setDelegate:nil];
    [albums setDelegate:nil];
    NSLog(@"End dealloc");
}

@end
