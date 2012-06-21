//
//  ANPhotoDownloader.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANPhotoDownloader.h"

#define NSMKDIR(x) [[NSFileManager defaultManager] createDirectoryAtPath:x withIntermediateDirectories:YES attributes:nil error:nil]

@interface ANPhotoDownloader (Private)

- (void)handleError:(NSError *)error;
- (void)handleProgress:(float)progress;
- (void)handleComplete;

- (void)beginFetchingProcess;
- (void)backgroundThread;
- (BOOL)fetchAlbums:(NSError **)errorOut;
- (BOOL)fetchPhotos:(NSError **)errorOut;
- (BOOL)fetchPhoto:(ANFBPhoto *)photo toPath:(NSString *)path error:(NSError **)errorOut;

@end

@implementation ANPhotoDownloader

@synthesize delegate;

- (id)initWithSession:(ANFBSession *)theSession directory:(NSString *)directory albums:(NSArray *)albums {
    self = [self initWithSession:session directory:directory albums:albums photos:nil];
    return self;
}

- (id)initWithSession:(ANFBSession *)theSession directory:(NSString *)directory photos:(NSArray *)photos {
    self = [self initWithSession:session directory:directory albums:nil photos:photos];
    return self;    
}

- (id)initWithSession:(ANFBSession *)theSession directory:(NSString *)directory albums:(NSArray *)albums photos:(NSArray *)photos {
    if ((self = [super init])) {
        downloadPath = directory;
        session = theSession;
        if (albums) {
            albumPhotos = [[ANFBAlbumPhotos alloc] initWithSession:session albums:albums];
            [albumPhotos setDelegate:self];
        }
        if (photos) {
            listedPhotos = photos;
        }
    }
    return self;
}

#pragma mark - Managing Downloads -

- (void)beginDownload {
    if (downloadStage != ANPhotoDownloaderStageUnstarted) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Download stage is not unstarted!"
                                     userInfo:nil];
    }
    callbackQueue = dispatch_get_current_queue();
    if (albumPhotos) {
        [albumPhotos beginFetching];
        downloadStage = ANPhotoDownloaderStageScanningAlbums;
    } else {
        downloadStage = ANPhotoDownloaderStageDownloadingPictures;
    }
    [self handleProgress:0];
}

- (void)cancelDownload {
    if (downloadStage == ANPhotoDownloaderStageScanningAlbums) {
        [albumPhotos cancelFetching];
    } else if (downloadStage == ANPhotoDownloaderStageDownloadingPictures) {
        [fetchThread cancel];
        fetchThread = nil;
        callbackQueue = NULL;
    }
}

- (BOOL)isLoading {
    return (downloadStage != ANPhotoDownloaderStageUnstarted);
}

#pragma mark - Album Photos -

- (void)albumPhotosComplete:(ANFBAlbumPhotos *)photos {
    [self beginFetchingProcess];
}

- (void)albumPhotos:(ANFBAlbumPhotos *)photos failedWithError:(NSError *)error {
    [self handleError:error];
}

- (void)albumPhotos:(ANFBAlbumPhotos *)photos fetchedAlbum:(ANFBAlbum *)album {
    float progress = (float)[photos fetchedAlbumCount] / (float)[[photos albums] count];
    [self handleProgress:progress];
}

#pragma mark - Delegate -

- (void)handleError:(NSError *)error {
    fetchThread = nil; // this should be the end of the thread (if it's running)
    if ([[NSThread currentThread] isCancelled]) return;
    dispatch_async(callbackQueue, ^{
        downloadStage = ANPhotoDownloaderStageUnstarted;
        if ([delegate respondsToSelector:@selector(photoDownloader:failedWithError:)]) {
            [delegate photoDownloader:self failedWithError:error];
        }
    });
    callbackQueue = NULL;
}

- (void)handleProgress:(float)progress {
    if ([[NSThread currentThread] isCancelled]) return;
    dispatch_async(callbackQueue, ^{
        if ([delegate respondsToSelector:@selector(photoDownloader:progress:forStage:)]) {
            NSString * stageStr = (downloadStage == ANPhotoDownloaderStageScanningAlbums ?
                                   @"Scanning Albums..." : @"Downloading Images");
            [delegate photoDownloader:self progress:progress forStage:stageStr];
        }
    });
}

- (void)handleComplete {
    fetchThread = nil; // this should be the end of the thread (if it's running)
    if ([[NSThread currentThread] isCancelled]) return;
    dispatch_async(callbackQueue, ^{
        downloadStage = ANPhotoDownloaderStageUnstarted;
        if ([delegate respondsToSelector:@selector(photoDownloaderComplete:)]) {
            [delegate photoDownloaderComplete:self];
        }
    });
    callbackQueue = NULL;
}

#pragma mark - Downloading -

#pragma mark Download Paths

- (NSString *)pathForPhoto:(ANFBPhoto *)photo inAlbum:(ANFBAlbum *)album {
    NSString * pathName = [[photo sourceURL] lastPathComponent];
    NSString * baseName = nil;
    if (listedPhotos) {
        baseName = [downloadPath stringByAppendingPathComponent:@"Albums"];
    } else {
        baseName = downloadPath;
    }
    baseName = [baseName stringByAppendingPathComponent:[album name]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:baseName]) {
        if (!NSMKDIR(baseName)) return nil;
    }
    NSString * imagePath = [baseName stringByAppendingPathComponent:pathName];
    return imagePath;
}

- (NSString *)pathForPhoto:(ANFBPhoto *)photo {
    NSString * pathName = [[photo sourceURL] lastPathComponent];
    NSString * baseName = nil;
    if (albumPhotos) {
        baseName = [downloadPath stringByAppendingPathComponent:@"Tagged Photos"];
    } else {
        baseName = downloadPath;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:baseName]) {
        if (!NSMKDIR(baseName)) return nil;
    }
    NSString * imagePath = [baseName stringByAppendingPathComponent:pathName];
    return imagePath;
}

#pragma mark Fetching

- (void)beginFetchingProcess {
    downloadStage = ANPhotoDownloaderStageDownloadingPictures;
    fetchThread = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundThread) object:nil];
    [fetchThread start];
}

- (void)backgroundThread {
    @autoreleasepool {
        NSError * error = nil;
        totalPhotos = [listedPhotos count] + [albumPhotos photoCount];
        photosFetched = 0;
        if (albumPhotos) {
            if (![self fetchAlbums:&error]) {
                [self handleError:error];
                return;
            }
        }
        if (listedPhotos) {
            if (![self fetchPhotos:&error]) {
                [self handleError:error];
                return;
            }
        }
        [self handleComplete];
    }
}

- (BOOL)fetchAlbums:(NSError **)errorOut {
    for (ANFBAlbum * album in albumPhotos.albums) {
        NSArray * photos = [albumPhotos photosForAlbum:album];
        for (ANFBPhoto * photo in photos) {
            NSString * path = [self pathForPhoto:photo inAlbum:album];
            if (!path) {
                NSDictionary * info = [NSDictionary dictionaryWithObject:@"Failed to generate download path."
                                                                  forKey:NSLocalizedDescriptionKey];
                NSError * error = [NSError errorWithDomain:@"ANPhotoDownloader" code:1 userInfo:info];
                if (errorOut) *errorOut = error;
                return NO;
            }
            if (![self fetchPhoto:photo toPath:path error:errorOut]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)fetchPhotos:(NSError **)errorOut {
    for (ANFBPhoto * photo in listedPhotos) {
        NSString * path = [self pathForPhoto:photo];
        if (!path) {
            NSDictionary * info = [NSDictionary dictionaryWithObject:@"Failed to generate download path."
                                                              forKey:NSLocalizedDescriptionKey];
            NSError * error = [NSError errorWithDomain:@"ANPhotoDownloader" code:1 userInfo:info];
            if (errorOut) *errorOut = error;
            return NO;
        }
        if (![self fetchPhoto:photo toPath:path error:errorOut]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)fetchPhoto:(ANFBPhoto *)photo toPath:(NSString *)path error:(NSError **)errorOut {
    if ([[NSThread currentThread] isCancelled]) {
        // the error will be passed to the -handleError: method, which
        // will be silent since the thread is cancelled.
        return NO;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[photo sourceURL]];
    NSData * photoData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:nil];
    if (!photoData) return YES; // we won't throw up because of one invalid URL
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [photo createdTime], NSFileCreationDate,
                                 [photo updatedTime], NSFileModificationDate, nil];
    if (![[NSFileManager defaultManager] createFileAtPath:path contents:photoData attributes:attributes]) {
        return NO;
    }
    photosFetched++;
    float progress = (float)photosFetched / (float)totalPhotos;
    [self handleProgress:progress];
    return YES;
}

@end
