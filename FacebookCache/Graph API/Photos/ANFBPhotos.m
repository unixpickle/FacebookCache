//
//  ANFBPhotos.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANFBPhotos.h"

@implementation ANFBPhotos

+ (NSString *)connectionPathFormat {
    return kANFBPhotosGraphURL;
}

+ (id)chainedObjectForDataEntry:(NSDictionary *)anEntry {
    return [[ANFBPhoto alloc] initWithDictionary:anEntry];
}

- (NSArray *)photos {
    return [self objectChain];
}

@end
