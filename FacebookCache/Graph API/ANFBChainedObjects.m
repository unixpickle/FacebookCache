//
//  ANFBChainedObjects.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBChainedObjects.h"

@interface ANFBChainedObjects (Private)

- (NSArray *)objectsForData:(NSArray *)data;

@end

@implementation ANFBChainedObjects

+ (id)chainedObjectForDataEntry:(NSDictionary *)anEntry {
    return nil;
}

+ (NSString *)connectionPathFormat {
    return nil;
}

- (id)initWithSession:(ANFBSession *)theSession facebookID:(NSString *)anID {
    NSString * urlString = [NSString stringWithFormat:[[self class] connectionPathFormat], anID];
    NSURL * url = [NSURL URLWithString:urlString];
    if ((self = [super initWithSession:theSession graphURL:url])) {
        objectChain = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)objectChain {
    return objectChain;
}

- (void)addCollectedData:(NSArray *)someItems {
    [super addCollectedData:someItems];
    [objectChain addObjectsFromArray:[self objectsForData:someItems]];
}

#pragma mark - Private -

- (NSArray *)objectsForData:(NSArray *)data {
    NSMutableArray * returnValue = [[NSMutableArray alloc] init];
    
    for (NSDictionary * pictureDict in data) {
        id object = [[self class] chainedObjectForDataEntry:pictureDict];
        if (object) [returnValue addObject:object];
    }
    
    return [NSArray arrayWithArray:returnValue];
}

@end
