//
//  ANFBChainedObjects.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBChainedData.h"

@interface ANFBChainedObjects : ANFBChainedData {
    NSMutableArray * objectChain;
}

+ (id)chainedObjectForDataEntry:(NSDictionary *)anEntry;
+ (NSString *)connectionPathFormat;

- (id)initWithSession:(ANFBSession *)theSession facebookID:(NSString *)anID;
- (NSArray *)objectChain;

@end
