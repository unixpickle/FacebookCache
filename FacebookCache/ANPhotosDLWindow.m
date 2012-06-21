//
//  ANPhotosDLWindow.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANPhotosDLWindow.h"

@interface ANPhotosDLWindow (Private)

+ (NSMutableSet *)photosDLWindows;

@end

@implementation ANPhotosDLWindow

+ (NSMutableSet *)photosDLWindows {
    static NSMutableSet * windows = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windows = [[NSMutableSet alloc] init];
    });
    return windows;
}

- (id)initWithSession:(ANFBSession *)session directory:(NSString *)directory photos:(NSArray *)photos albums:(NSArray *)albums {
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    NSRect windowFrame = NSMakeRect(0, 0, 400, 100);
    windowFrame.origin.x = (screenFrame.size.width - windowFrame.size.width) / 2;
    windowFrame.origin.y = (screenFrame.size.height - windowFrame.size.height) / 2;
    if ((self = [super initWithContentRect:windowFrame styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO])) {
        self.title = [NSString stringWithFormat:@"Downloading to \"%@\"", [directory lastPathComponent]];;
        downloader = [[ANPhotoDownloader alloc] initWithSession:session directory:directory albums:albums photos:photos];
        [downloader setDelegate:self];
        
        // generate UI
        progressField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, windowFrame.size.height - 25, windowFrame.size.width - 20, 15)];
        progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(10, windowFrame.size.height - 50,
                                                                                  windowFrame.size.width - 20, 20)];
        closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(windowFrame.size.width - 100, 10, 90, 32)];
        
        [progressField setBackgroundColor:[NSColor clearColor]];
        [progressField setBordered:NO];
        [progressField setSelectable:NO];
        [progressField setStringValue:@"factum incipit ut faciendum erat..."];
        [[self contentView] addSubview:progressField];
        
        [progressIndicator setControlSize:NSRegularControlSize];
        [progressIndicator setStyle:NSProgressIndicatorBarStyle];
        [progressIndicator setMinValue:0];
        [progressIndicator setMaxValue:1];
        [progressIndicator setIndeterminate:NO];
        [progressIndicator startAnimation:self];
        [[self contentView] addSubview:progressIndicator];
        
        [closeButton setBezelStyle:NSRoundedBezelStyle];
        [closeButton setTitle:@"Cancel"];
        [closeButton setFont:[NSFont systemFontOfSize:13]];
        [closeButton setTarget:self];
        [closeButton setAction:@selector(closeButtonPressed:)];
        [[self contentView] addSubview:closeButton];
        
        [self setDefaultButtonCell:[closeButton cell]];
    }
    return self;
}

- (void)beginDownloading {
    [downloader beginDownload];
}

- (void)closeButtonPressed:(id)sender {
    if ([downloader isLoading]) [downloader cancelDownload];
    [self orderOut:self];
}

- (void)makeKeyAndOrderFront:(id)sender {
    [super makeKeyAndOrderFront:sender];
    [[[self class] photosDLWindows] addObject:self];
}

- (void)orderOut:(id)sender {
    [super orderOut:sender];
    [[[self class] photosDLWindows] removeObject:self];
}

#pragma mark - Photo Downloader -

- (void)photoDownloaderComplete:(ANPhotoDownloader *)downloader {
    [self orderOut:self];
}

- (void)photoDownloader:(ANPhotoDownloader *)downloader progress:(float)progress forStage:(NSString *)status {
    [progressIndicator setDoubleValue:(double)progress];
    [progressField setStringValue:status];
}

- (void)photoDownloader:(ANPhotoDownloader *)downloader failedWithError:(NSError *)error {
    [progressIndicator setAlphaValue:0.5];
    [progressField setStringValue:[NSString stringWithFormat:@"Error: %@", error]];
}

@end
