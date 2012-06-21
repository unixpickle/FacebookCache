//
//  ANPhotoDownloader.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANFBAlbumPhotos.h"
#import "ANFBPhotos.h"

typedef enum {
    ANPhotoDownloaderStageUnstarted = 0,
    ANPhotoDownloaderStageScanningAlbums = 1,
    ANPhotoDownloaderStageDownloadingPictures = 2
} ANPhotoDownloaderStage;

@class ANPhotoDownloader;

@protocol ANPhotoDownloaderDelegate <NSObject>

@optional
- (void)photoDownloader:(ANPhotoDownloader *)downloader progress:(float)progress forStage:(NSString *)status;
- (void)photoDownloaderComplete:(ANPhotoDownloader *)downloader;
- (void)photoDownloader:(ANPhotoDownloader *)downloader failedWithError:(NSError *)error;

@end

@interface ANPhotoDownloader : NSObject <ANFBAlbumPhotosDelegate> {
    __weak ANFBSession * session;
    ANFBAlbumPhotos * albumPhotos;
    NSArray * listedPhotos;
    
    NSString * downloadPath;    
    ANPhotoDownloaderStage downloadStage;
    __unsafe_unretained id<ANPhotoDownloaderDelegate> delegate;
    
    dispatch_queue_t callbackQueue;
    NSThread * fetchThread;
    NSInteger totalPhotos;
    NSInteger photosFetched;
}

@property (nonatomic, assign) id<ANPhotoDownloaderDelegate> delegate;

- (id)initWithSession:(ANFBSession *)theSession directory:(NSString *)directory albums:(NSArray *)albums;
- (id)initWithSession:(ANFBSession *)theSession directory:(NSString *)directory photos:(NSArray *)photos;
- (id)initWithSession:(ANFBSession *)theSession directory:(NSString *)directory albums:(NSArray *)albums photos:(NSArray *)photos;

- (void)beginDownload;
- (void)cancelDownload;
- (BOOL)isLoading;

- (NSString *)pathForPhoto:(ANFBPhoto *)photo inAlbum:(ANFBAlbum *)album;
- (NSString *)pathForPhoto:(ANFBPhoto *)photo;

@end
