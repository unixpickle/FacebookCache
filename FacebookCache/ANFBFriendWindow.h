//
//  ANFBFriendWindow.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANFBAlbums.h"
#import "ANFBPhotos.h"
#import "ANDownloadsWindow.h"

@interface ANFBFriendWindow : NSWindow <ANFBChainedDataDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    ANFBSession * session;
    ANFBPerson * friend;
    ANFBPhotos * photos;
    ANFBAlbums * albums;
    
    NSProgressIndicator * photosProgress;
    NSProgressIndicator * albumsProgress;
    NSButton * downloadPhotosButton;
    NSButton * downloadAlbumsButton;
    NSButton * downloadBothButton;
    NSTableView * photosTable;
    NSTableView * albumsTable;
    
    NSMutableArray * disabledAlbums;
}

- (id)initWithSession:(ANFBSession *)theSession friend:(ANFBPerson *)aPerson;
- (NSRect)photosTableFrame;
- (NSRect)albumsTableFrame;
- (void)createPhotosTable;
- (void)createAlbumsTable;

- (void)downloadDialog:(NSString *)path photos:(NSArray *)photos albums:(NSArray *)albums;
- (NSArray *)selectedAlbums;

- (void)downloadPhotos:(id)sender;
- (void)downloadAlbums:(id)sender;
- (void)downloadBoth:(id)sender;

@end
