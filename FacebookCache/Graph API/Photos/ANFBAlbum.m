//
//  ANFBAlbum.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBAlbum.h"

@implementation ANFBAlbum

@synthesize albumID;
@synthesize from;
@synthesize name;
@synthesize description;
@synthesize createdTime;
@synthesize updatedTime;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init])) {
        albumID = [dictionary objectForKey:@"id"];
        from = [[ANFBPerson alloc] initWithUserObject:[dictionary objectForKey:@"from"]];
        name = [dictionary objectForKey:@"name"];
        description = [dictionary objectForKey:@"description"];
        createdTime = [NSDate dateByParsingFacebookDate:[dictionary objectForKey:@"created_time"]];
        updatedTime = [NSDate dateByParsingFacebookDate:[dictionary objectForKey:@"updated_time"]];
    }
    return self;
}

@end
