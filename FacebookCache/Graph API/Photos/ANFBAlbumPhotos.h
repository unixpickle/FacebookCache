//
//  ANFBAlbumPhotos.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANFBAlbum.h"
#import "ANFBPhotos.h"

@class ANFBAlbumPhotos;

@protocol ANFBAlbumPhotosDelegate <NSObject>

@optional
- (void)albumPhotos:(ANFBAlbumPhotos *)photos fetchedAlbum:(ANFBAlbum *)album;
- (void)albumPhotosComplete:(ANFBAlbumPhotos *)photos;
- (void)albumPhotos:(ANFBAlbumPhotos *)photos failedWithError:(NSError *)error;

@end

@interface ANFBAlbumPhotos : NSObject <ANFBChainedDataDelegate> {
    NSArray * albums;
    NSInteger albumIndex;
    NSMutableDictionary * photosForAlbum;
    __unsafe_unretained id<ANFBAlbumPhotosDelegate> delegate;
    
    ANFBPhotos * currentFetcher;
    __weak ANFBSession * session;
}

@property (nonatomic, assign) id<ANFBAlbumPhotosDelegate> delegate;
@property (readonly) NSArray * albums;

- (id)initWithSession:(ANFBSession *)theSession albums:(NSArray *)theAlbums;
- (void)beginFetching;
- (void)cancelFetching;
- (BOOL)isLoading;

- (NSArray *)photosForAlbum:(ANFBAlbum *)album;
- (NSUInteger)fetchedAlbumCount;
- (NSUInteger)photoCount;

@end
