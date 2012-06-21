//
//  ANCancelButton.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kANCancelButtonSize 16

@interface ANCancelButton : NSView {
    BOOL isPressed;
    BOOL enabled;
    BOOL isHovered;
    __weak id target;
    SEL action;
    NSTrackingArea * trakcingArea;
}

@property (nonatomic, weak) id target;
@property (readwrite) SEL action;
@property (readwrite, getter = isEnabled) BOOL enabled;

+ (NSArray *)buttonImages;

- (id)initWithFrame:(NSRect)frameRect target:(id)aTarget action:(SEL)anAction;
- (void)triggerEvent;

@end
