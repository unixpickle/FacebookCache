//
//  ANFBAlbums.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBChainedObjects.h"
#import "ANFBAlbum.h"

#define kANFBAlbumsGraphURL @"https://graph.facebook.com/%@/albums"

@interface ANFBAlbums : ANFBChainedObjects

- (NSArray *)albums;

@end
