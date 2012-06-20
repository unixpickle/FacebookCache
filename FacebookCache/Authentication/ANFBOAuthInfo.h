//
//  ANFBOAuthInfo.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANFBOAuthInfo : NSObject {
    NSString * accessToken;
    NSTimeInterval expiresIn;
    NSDate * obtainedDate;
}

@property (readonly) NSString * accessToken;
@property (readonly) NSTimeInterval expiresIn;
@property (readonly) NSDate * obtainedDate;

- (id)initWithResponseURL:(NSURL *)theURL;

@end
