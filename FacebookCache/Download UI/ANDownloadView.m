//
//  ANDownloadView.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANDownloadView.h"

static CGSize sizeForString(NSString * myString, NSFont * myFont);

@implementation ANDownloadView

@synthesize drawDivider;
@synthesize backgroundColor;
@synthesize delegate;

- (id)initWithSession:(ANFBSession *)theSession personID:(NSString *)uid directory:(NSString *)directory photos:(NSArray *)photos albums:(NSArray *)albums {
    NSRect viewFrame = NSMakeRect(0, 0, kANDownloadViewWidth, kANDownloadViewHeight);
    if ((self = [super initWithFrame:viewFrame])) {
        session = theSession;
        downloader = [[ANPhotoDownloader alloc] initWithSession:session directory:directory albums:albums photos:photos];
        [downloader setDelegate:self];
        NSString * progressTitle = [NSString stringWithFormat:@"Downloading to \"%@\"", [directory lastPathComponent]];
        
        // generate UI
        backgroundColor = [NSColor whiteColor];
        
        progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(60, 26, viewFrame.size.width - 94, 12)];
        [progressIndicator setIndeterminate:NO];
        [progressIndicator setMaxValue:1];
        [progressIndicator setDoubleValue:0];
        [progressIndicator setControlSize:NSMiniControlSize];
        [self addSubview:progressIndicator];
        
        cancelButton = [[ANCancelButton alloc] initWithFrame:NSMakeRect(371, 26, kANCancelButtonSize, kANCancelButtonSize)];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(closeButtonPressed:)];
        [self addSubview:cancelButton];
        
        subtitleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(60, 10, 320, 11)];
        [subtitleLabel setBordered:NO];
        [subtitleLabel setSelectable:NO];
        [subtitleLabel setBackgroundColor:[NSColor clearColor]];
        [subtitleLabel setStringValue:@"incipit dum hoc legis..."];
        [subtitleLabel setFont:[NSFont systemFontOfSize:9]];
        [self addSubview:subtitleLabel];
        
        titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(60, 38 + 8, 320, 14)];
        [titleLabel setBordered:NO];
        [titleLabel setSelectable:NO];
        [titleLabel setBackgroundColor:[NSColor clearColor]];
        [titleLabel setStringValue:[self shrinkText:progressTitle withLabel:titleLabel]];
        [titleLabel setFont:[NSFont systemFontOfSize:11]];
        [self addSubview:titleLabel];
        
        iconImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(10, 22, 32, 32)];
        [iconImageView setImage:[NSImage imageNamed:@"blank.jpg"]];
        [self addSubview:iconImageView];
        
        NSString * picURLStr = [NSString stringWithFormat:kANFacebookProfilePicturePath, uid];
        NSURL * picURL = [NSURL URLWithString:picURLStr];
        NSURLRequest * picReq = [NSURLRequest requestWithURL:picURL];
        iconTicket = [session sendRequestAsynchronously:picReq callback:^(ANFBResponse * response, NSError * error) {
            if ([response responseData]) {
                NSImage * image = [[NSImage alloc] initWithData:[response responseData]];
                if (image) {
                    [iconImageView setImage:image];
                }
            }
            iconTicket = nil;
        }];
    }
    return self;
}

- (void)beginDownloading {
    [downloader beginDownload];
}

#pragma mark - Actions -

- (void)okayButtonPressed:(id)sender {
    if (iconTicket) [session cancelTicket:iconTicket];
    [delegate downloadViewFinished:self];
}

- (void)closeButtonPressed:(id)sender {
    if (iconTicket) [session cancelTicket:iconTicket];
    if ([downloader isLoading]) [downloader cancelDownload];
    [delegate downloadViewFinished:self];
}

#pragma mark - Photo Downloader -

- (void)photoDownloaderComplete:(ANPhotoDownloader *)downloader {
    if (iconTicket) [session cancelTicket:iconTicket];
    [delegate downloadViewFinished:self];
}

- (void)photoDownloader:(ANPhotoDownloader *)downloader progress:(float)progress forStage:(NSString *)status {
    [progressIndicator setDoubleValue:(double)progress];
    [subtitleLabel setStringValue:[status stringByAppendingFormat:@" - %d%%", (int)round(progress * 100)]];
}

- (void)photoDownloader:(ANPhotoDownloader *)downloader failedWithError:(NSError *)error {
    [progressIndicator setAlphaValue:0.5];
    [subtitleLabel setStringValue:[NSString stringWithFormat:@"Error: %@", error]];
    
    okayButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.frame.size.width - 106, 10, 96, 20)];
    [okayButton.cell setControlSize:NSSmallControlSize]; 
    [okayButton setBezelStyle:NSRoundedBezelStyle];
    [okayButton setTitle:@"OK"];
    [okayButton setTarget:self];
    [okayButton setAction:@selector(okayButtonPressed:)];
    [okayButton setFont:[NSFont systemFontOfSize:11]];
    [self addSubview:okayButton];
    
    NSString * errorString = [error localizedDescription];
    NSString * shrunk = [self shrinkText:errorString withLabel:titleLabel];
    [titleLabel setStringValue:shrunk];
    
    [subtitleLabel removeFromSuperview];
    [cancelButton removeFromSuperview];
    [progressIndicator removeFromSuperview];
}

#pragma mark - UI Drawing -

- (NSString *)shrinkText:(NSString *)text withLabel:(NSTextField *)label {
    CGFloat maxWidth = label.frame.size.width;
    NSFont * font = [label font];
    NSString * testString = text;
    NSInteger cutLength = 1, cutStart = [text length] / 2;
    while (sizeForString(testString, font).width > maxWidth) {
        cutLength += 1;
        cutStart = [text length] / 2 + cutLength / 2;
        if (cutStart - cutLength < 0) cutStart++;
        if (cutStart >= [text length]) return nil;
        testString = [text stringByReplacingCharactersInRange:NSMakeRange(cutStart - cutLength, cutLength)
                                                   withString:@"..."];
    }
    return testString;
}

- (void)drawRect:(NSRect)dirtyRect {
    [backgroundColor set];
    NSRectFill(self.bounds);
    if (drawDivider) {
        [[NSColor colorWithDeviceWhite:0.66667 alpha:1] set];
        NSRectFill(NSMakeRect(0, 0, self.frame.size.width, 1));
    }
}

#pragma mark - Memory -

- (void)dealloc {
    if (iconTicket) [session cancelTicket:iconTicket];
}

@end

static CGSize sizeForString(NSString * myString, NSFont * myFont) {
    NSTextStorage * textStorage = [[NSTextStorage alloc] initWithString:myString];
    NSTextContainer * textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager usedRectForTextContainer:textContainer].size;
}
