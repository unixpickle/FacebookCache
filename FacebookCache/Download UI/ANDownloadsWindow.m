//
//  ANDownloadsWindow.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANDownloadsWindow.h"

@implementation ANDownloadsWindow

+ (ANDownloadsWindow *)sharedDownloadsWindow {
    static ANDownloadsWindow * window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[ANDownloadsWindow alloc] init];
    });
    return window;
}

- (id)init {
    NSRect screen = [[NSScreen mainScreen] frame];
    CGFloat y = screen.size.height - 500;
    if ((self = [super initWithContentRect:NSMakeRect(300, y, 400, 1)
                                 styleMask:(NSTitledWindowMask | NSMiniaturizableWindowMask)
                                   backing:NSBackingStoreBuffered defer:NO])) {
        downloadViews = [[NSMutableArray alloc] init];
        self.title = @"Downloads";
        [self setLevel:CGShieldingWindowLevel()];
        [self setAcceptsMouseMovedEvents:YES];
    }
    return self;
}

- (void)pushDownloadView:(ANDownloadView *)aView {
    [aView setDelegate:self];    
    [downloadViews addObject:aView];
    [self.contentView addSubview:aView];
    [self layoutDownloadViews];
    if (!isVisible) {
        [self makeKeyAndOrderFront:self];
        isVisible = YES;
    }
    [aView beginDownloading];
}

- (void)layoutDownloadViews {
    CGFloat totalHeight = [downloadViews count] * kANDownloadViewHeight;
    CGFloat y = totalHeight - kANDownloadViewHeight;
    for (int i = 0; i < [downloadViews count]; i++) {
        ANDownloadView * view = [downloadViews objectAtIndex:i];
        if (i % 2 == 0) {
            view.backgroundColor = [NSColor colorWithCalibratedWhite:0.98 alpha:1];
        } else {
            view.backgroundColor = [NSColor colorWithCalibratedRed:0.94118 green:0.976 blue:0.996 alpha:1];
        }
        view.frame = NSMakeRect(0, y, [self.contentView frame].size.width, view.frame.size.height);
        view.drawDivider = (i + 1 < [downloadViews count] ? YES : NO);
        [view setNeedsDisplay:YES];
        y -= view.frame.size.height;
    }
    NSRect frame = self.frame;
    frame.size.height = totalHeight;
    NSRect frameRect = [self frameRectForContentRect:frame];
    frameRect.origin.y -= (frameRect.size.height - self.frame.size.height);
    [self setFrame:frameRect display:YES];
}

#pragma mark - Download Views -

- (void)downloadViewFinished:(ANDownloadView *)view {
    [downloadViews removeObject:view];
    [view removeFromSuperview];
    if ([downloadViews count] == 0 && isVisible) {
        [self orderOut:self];
        isVisible = NO;
    }
    [self layoutDownloadViews];
}

@end
