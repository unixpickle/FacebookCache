//
//  ANFBPerson.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBPerson.h"

@implementation ANFBPerson

@synthesize userID;
@synthesize name;
@synthesize username;

- (id)initWithUserObject:(NSDictionary *)userObject {
    if ((self = [super init])) {
        if (![userObject isKindOfClass:[NSDictionary class]]) return nil;
        userID = [userObject objectForKey:@"id"];
        name = [userObject objectForKey:@"name"];
        username = [userObject objectForKey:@"username"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p: {name=\"%@\", id=\"%@\"}>",
            NSStringFromClass([self class]), self, name, userID];
}

@end
