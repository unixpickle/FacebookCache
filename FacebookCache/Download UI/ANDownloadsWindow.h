//
//  ANDownloadsWindow.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANDownloadView.h"

@interface ANDownloadsWindow : NSWindow <ANDownloadViewDelegate> {
    BOOL isVisible;
    NSMutableArray * downloadViews;
}

+ (ANDownloadsWindow *)sharedDownloadsWindow;
- (void)pushDownloadView:(ANDownloadView *)aView;

- (void)layoutDownloadViews;

@end
