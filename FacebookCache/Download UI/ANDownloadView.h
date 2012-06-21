//
//  ANDownloadView.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANPhotoDownloader.h"
#import "ANCancelButton.h"

#define kANDownloadViewHeight 68
#define kANDownloadViewWidth 400

#define kANFacebookProfilePicturePath @"https://graph.facebook.com/%@/picture"

@class ANDownloadView;

@protocol ANDownloadViewDelegate <NSObject>

- (void)downloadViewFinished:(ANDownloadView *)view;

@end

@interface ANDownloadView : NSView <ANPhotoDownloaderDelegate> {
    ANPhotoDownloader * downloader;
    __weak ANFBSession * session;
    
    NSTextField * titleLabel;
    NSTextField * subtitleLabel;
    NSProgressIndicator * progressIndicator;
    ANCancelButton * cancelButton;
    NSButton * okayButton;
    
    ANFBSessionTicket * iconTicket;
    NSImageView * iconImageView;
    
    NSColor * backgroundColor;
    BOOL drawDivider;
    __unsafe_unretained id<ANDownloadViewDelegate> delegate;
}

@property (readwrite) BOOL drawDivider;
@property (nonatomic, retain) NSColor * backgroundColor;
@property (nonatomic, assign) __unsafe_unretained id<ANDownloadViewDelegate> delegate;

- (id)initWithSession:(ANFBSession *)session personID:(NSString *)uid directory:(NSString *)directory photos:(NSArray *)photos albums:(NSArray *)albums;
- (void)beginDownloading;
- (void)closeButtonPressed:(id)sender;
- (void)okayButtonPressed:(id)sender;

- (NSString *)shrinkText:(NSString *)text withLabel:(NSTextField *)label;

@end
