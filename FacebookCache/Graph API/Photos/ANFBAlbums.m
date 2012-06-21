//
//  ANFBAlbums.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBAlbums.h"

@implementation ANFBAlbums

+ (NSString *)connectionPathFormat {
    return kANFBAlbumsGraphURL;
}

+ (id)chainedObjectForDataEntry:(NSDictionary *)anEntry {
    return [[ANFBAlbum alloc] initWithDictionary:anEntry];
}

- (NSArray *)albums {
    return [self objectChain];
}

@end
