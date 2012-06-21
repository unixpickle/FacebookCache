//
//  ANFBChainedData.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBChainedData.h"

@interface ANFBChainedData (Private)

- (void)fetchNextPage;
- (void)handleFetchError:(NSError *)anError;
- (void)handleFetchComplete;

@end

@implementation ANFBChainedData

@synthesize delegate;
@synthesize session;
@synthesize pagesRead;

- (id)initWithSession:(ANFBSession *)theSession graphURL:(NSURL *)firstPage {
    if ((self = [super init])) {
        session = theSession;
        currentPageURL = firstPage;
        collectedData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)beginFetching {
    if (currentPageTicket) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"ANFBChainedData is already fetching a page."
                                     userInfo:nil];
    }
    [self fetchNextPage];
}

- (void)cancelFetching {
    if (currentPageTicket) {
        [session cancelTicket:currentPageTicket];
        currentPageTicket = nil;
    }
}

- (BOOL)isLoading {
    return (currentPageTicket != nil);
}

#pragma mark - Collected Data -

- (void)addCollectedData:(NSArray *)someItems {
    [collectedData addObjectsFromArray:someItems];
}

- (NSArray *)collectedData {
    return (NSArray *)collectedData;
}
     
#pragma mark - Private -

- (void)fetchNextPage {
    if (!currentPageURL) {
        return;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:currentPageURL
                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                          timeoutInterval:60];
    currentPageTicket = [session sendRequestAsynchronously:request callback:^(ANFBResponse * response, NSError * error) {
        currentPageTicket = nil;
        if (error || !response) {
            [self handleFetchError:error];
        } else if ([response isErrorMessage]) {
            [self handleFetchError:[response responseError]];
        } else {
            NSArray * dataArray = [response responseDataArray];
            if (dataArray) {
                [self addCollectedData:dataArray];
            }
            
            NSURL * nextPageURL = [response nextPage];
            if (nextPageURL && ![nextPageURL isEqual:currentPageURL]) {
                currentPageURL = nextPageURL;
                [self fetchNextPage];
            } else {
                [self handleFetchComplete];
            }
        }
    }];
}

- (void)handleFetchError:(NSError *)anError {
    if ([delegate respondsToSelector:@selector(chainedData:failedWithError:)]) {
        [delegate chainedData:self failedWithError:anError];
    }
}

- (void)handleFetchComplete {
    if ([delegate respondsToSelector:@selector(chainedDataFetched:)]) {
        [delegate chainedDataFetched:self];
    }
}

@end
