//
// ANFBPerson.m
// FacebookCache
//
// Created by Alex Nichol on 6/20/12.
// Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBPhoto.h"

@implementation ANFBPhoto

@synthesize pictureID;
@synthesize from;
@synthesize pictureURL;
@synthesize sourceURL;
@synthesize width;
@synthesize height;
@synthesize createdTime;
@synthesize updatedTime;
@synthesize likes;

- (id)initWithDictionary:(NSDictionary *)pictureInfo {
    if ((self = [super init])) {
        pictureID = [pictureInfo objectForKey:@"id"];
        from = [[ANFBPerson alloc] initWithUserObject:[pictureInfo objectForKey:@"from"]];
        pictureURL = [NSURL URLWithString:[pictureInfo objectForKey:@"picture"]];
        sourceURL = [NSURL URLWithString:[pictureInfo objectForKey:@"source"]];
        width = [[pictureInfo objectForKey:@"width"] intValue];
        height = [[pictureInfo objectForKey:@"height"] intValue];
        createdTime = [NSDate dateByParsingFacebookDate:[pictureInfo objectForKey:@"created_time"]];
        updatedTime = [NSDate dateByParsingFacebookDate:[pictureInfo objectForKey:@"updated_time"]];
        
        NSArray * likesArray = [[pictureInfo objectForKey:@"likes"] objectForKey:@"data"];
        NSMutableArray * mLikes = [NSMutableArray array];
        for (NSDictionary * personDict in likesArray) {
            ANFBPerson * person = [[ANFBPerson alloc] initWithUserObject:personDict];
            if (person) [mLikes addObject:person];
        }
        likes = [[NSArray alloc] initWithArray:mLikes];
    }
    return self;
}

@end
