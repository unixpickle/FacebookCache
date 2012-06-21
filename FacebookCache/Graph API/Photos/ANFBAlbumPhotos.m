//
//  ANFBAlbumPhotos.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBAlbumPhotos.h"

@interface ANFBAlbumPhotos (Private)

- (void)fetchNextAlbum;
- (void)informDelegateDone;
- (void)informDelegateError:(NSError *)error;
- (void)informDelegateAlbum:(ANFBAlbum *)album;

@end

@implementation ANFBAlbumPhotos

@synthesize delegate;
@synthesize albums;

- (id)initWithSession:(ANFBSession *)theSession albums:(NSArray *)theAlbums {
    if ((self = [super init])) {
        session = theSession;
        albums = theAlbums;
        photosForAlbum = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)beginFetching {
    if (currentFetcher) {
        [currentFetcher cancelFetching];
        currentFetcher = nil;
    }
    [photosForAlbum removeAllObjects];
    albumIndex = 0;
    [self fetchNextAlbum];
}

- (void)cancelFetching {
    [currentFetcher cancelFetching];
    currentFetcher = nil;
}

- (BOOL)isLoading {
    if ([currentFetcher isLoading]) return YES;
    return NO;
}

- (NSArray *)photosForAlbum:(ANFBAlbum *)album {
    return [photosForAlbum objectForKey:album.albumID];
}

- (NSUInteger)fetchedAlbumCount {
    return [photosForAlbum count];
}

- (NSUInteger)photoCount {
    NSUInteger count = 0;
    for (id key in photosForAlbum) {
        count += [[photosForAlbum objectForKey:key] count];
    }
    return count;
}

#pragma mark - Photos Fetcher -

- (void)chainedData:(ANFBChainedData *)chain failedWithError:(NSError *)anError {
    [self informDelegateError:anError];
    currentFetcher = nil;
}

- (void)chainedDataFetched:(ANFBChainedData *)chain {
    ANFBAlbum * album = [albums objectAtIndex:albumIndex];
    NSArray * photos = [currentFetcher photos];
    [photosForAlbum setObject:photos
                       forKey:album.albumID];
    [self informDelegateAlbum:album];
    
    albumIndex++;
    if (albumIndex == [albums count]) {
        currentFetcher = nil;
        [self informDelegateDone];
    } else {
        [self fetchNextAlbum];
    }
}

#pragma mark - Private -

- (void)fetchNextAlbum {
    if ([albums count] <= albumIndex) {
        [self informDelegateDone];
        return;
    }
    ANFBAlbum * album = [albums objectAtIndex:albumIndex];
    currentFetcher = [[ANFBPhotos alloc] initWithSession:session facebookID:album.albumID];
    [currentFetcher setDelegate:self];
    [currentFetcher beginFetching];
}

- (void)informDelegateDone {
    if ([delegate respondsToSelector:@selector(albumPhotosComplete:)]) {
        [delegate albumPhotosComplete:self];
    }
}

- (void)informDelegateError:(NSError *)error {
    if ([delegate respondsToSelector:@selector(albumPhotos:failedWithError:)]) {
        [delegate albumPhotos:self failedWithError:error];
    }
}

- (void)informDelegateAlbum:(ANFBAlbum *)album {
    if ([delegate respondsToSelector:@selector(albumPhotos:fetchedAlbum:)]) {
        [delegate albumPhotos:self fetchedAlbum:album];
    }
}

@end
