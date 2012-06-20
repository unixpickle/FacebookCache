//
//  ANFBAuthWindow.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBAuthWindow.h"

@interface ANFBAuthWindow (Private)

- (void)processOAuthResponse:(NSURL *)request;
- (void)informDelegateInfo:(ANFBOAuthInfo *)info;

@end

@implementation ANFBAuthWindow

@synthesize delegate;

- (id)initWithScreen:(NSScreen *)aScreen {
    NSRect windowFrame = NSMakeRect(0, 0, 900, 600);
    windowFrame.origin.x = ([aScreen frame].size.width - windowFrame.size.width) / 2;
    windowFrame.origin.y = ([aScreen frame].size.height - windowFrame.size.height) / 2;
    return ((self = [self initWithContentRect:windowFrame
                                     styleMask:(NSTitledWindowMask | NSClosableWindowMask)
                                       backing:NSBackingStoreBuffered
                                         defer:NO
                                        screen:aScreen]));
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
    if ((self = [super initWithContentRect:contentRect
                                 styleMask:aStyle
                                   backing:bufferingType
                                     defer:flag
                                    screen:screen])) {
        self.title = @"Facebook Authentication";
        webView = [[WebView alloc] initWithFrame:[self.contentView bounds] frameName:@"frame" groupName:@"group"];
        [webView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
        [self.contentView addSubview:webView];
        // load authentication URL
        [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[self generateOAuthURL]]];
        [webView setResourceLoadDelegate:self];
    }
    return self;
}

- (NSURL *)generateOAuthURL {
    NSString * redirectURL = [NSString stringWithFormat:@"https://www.facebook.com/connect/login_success.html"];
    NSString * urlString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&scope=%@&response_type=%@",
                            kFacebookOAuthURL, kFacebookAppID, redirectURL, kFacebookPermissions, @"token"];
    return [NSURL URLWithString:urlString];
}

#pragma mark - OAuth Callback Server -

- (void)webView:(WebView *)sender willPerformClientRedirectToURL:(NSURL *)URL delay:(NSTimeInterval)seconds fireDate:(NSDate *)date forFrame:(WebFrame *)frame {
    [self processOAuthResponse:URL];
}

- (void)webView:(WebView *)sender didReceiveServerRedirectForProvisionalLoadForFrame:(WebFrame *)frame {
    NSLog(@"%@", [(NSHTTPURLResponse *)[[frame dataSource] response] allHeaderFields]);
}

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource {
    NSLog(@"URL: %@", request.URL);
    [self processOAuthResponse:[request URL]];
    return request;
}

- (void)processOAuthResponse:(NSURL *)requestURL {
    if (![[requestURL host] isEqualToString:@"www.facebook.com"]) return;
    NSString * path = [requestURL path];
    
    if (![path hasPrefix:@"/connect/login_success.html"]) return;
    ANFBOAuthInfo * info = [[ANFBOAuthInfo alloc] initWithResponseURL:requestURL];
    if (info) {
        [self informDelegateInfo:info];
    }
}

- (void)informDelegateInfo:(ANFBOAuthInfo *)info {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(informDelegateInfo:)
                               withObject:info
                            waitUntilDone:NO];
        return;
    }
    if ([delegate respondsToSelector:@selector(authWindow:didAuthenticate:)]) {
        [delegate authWindow:self didAuthenticate:info];
    }
}

@end
