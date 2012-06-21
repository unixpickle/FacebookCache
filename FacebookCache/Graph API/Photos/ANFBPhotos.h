//
//  ANFBPhotos.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBChainedObjects.h"
#import "ANFBPhoto.h"

#define kANFBPhotosGraphURL @"https://graph.facebook.com/%@/photos"

@interface ANFBPhotos : ANFBChainedObjects

- (NSArray *)photos;

@end
