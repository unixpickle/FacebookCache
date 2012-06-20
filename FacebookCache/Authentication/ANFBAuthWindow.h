//
//  ANFBAuthWindow.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "ANFBOAuthInfo.h"

#define kFacebookAppID @"417617131616781"
#define kFacebookOAuthURL @"https://www.facebook.com/dialog/oauth"
#define kFacebookPermissions @"user_about_me,friends_about_me,user_photos,friends_photos,user_videos,friends_videos"

@class ANFBAuthWindow;

@protocol ANFBAuthWindowDelegate <NSObject>

- (void)authWindow:(ANFBAuthWindow *)aWindow didAuthenticate:(ANFBOAuthInfo *)info;

@end

@interface ANFBAuthWindow : NSWindow {
    WebView * webView;
    __weak id<ANFBAuthWindowDelegate> delegate;
}

@property (nonatomic, weak) id<ANFBAuthWindowDelegate> delegate;

- (id)initWithScreen:(NSScreen *)aScreen;
- (NSURL *)generateOAuthURL;

@end
