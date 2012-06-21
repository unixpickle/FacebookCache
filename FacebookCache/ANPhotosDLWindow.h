//
//  ANPhotosDLWindow.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANPhotoDownloader.h"

@interface ANPhotosDLWindow : NSWindow <ANPhotoDownloaderDelegate> {
    ANPhotoDownloader * downloader;
    NSProgressIndicator * progressIndicator;
    NSTextField * progressField;
    NSButton * closeButton;
}

- (id)initWithSession:(ANFBSession *)session directory:(NSString *)directory photos:(NSArray *)photos albums:(NSArray *)albums;
- (void)beginDownloading;
- (void)closeButtonPressed:(id)sender;

@end
