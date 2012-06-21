//
//  ANFBChainedData.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANFBSession.h"

@class ANFBChainedData;

@protocol ANFBChainedDataDelegate <NSObject>

@optional
- (void)chainedDataFetched:(ANFBChainedData *)chain;
- (void)chainedData:(ANFBChainedData *)chain failedWithError:(NSError *)anError;

@end

@interface ANFBChainedData : NSObject {
    NSMutableArray * collectedData;
    __weak ANFBSession * session;
    __unsafe_unretained id<ANFBChainedDataDelegate> delegate;
    
    NSURL * currentPageURL;
    ANFBSessionTicket * currentPageTicket;
    NSInteger pagesRead;
}

@property (nonatomic, assign) id<ANFBChainedDataDelegate> delegate;
@property (nonatomic, weak) ANFBSession * session;
@property (readonly) NSInteger pagesRead;

- (id)initWithSession:(ANFBSession *)theSession graphURL:(NSURL *)firstPage;
- (void)beginFetching;
- (void)cancelFetching;
- (BOOL)isLoading;

- (void)addCollectedData:(NSArray *)someItems;
- (NSArray *)collectedData;

@end
