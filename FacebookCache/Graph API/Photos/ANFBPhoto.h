//
//  ANFBPerson.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Facebook.h"
#import "ANFBPerson.h"

@interface ANFBPhoto : NSObject {
    NSString * pictureID;
    ANFBPerson * from;
    NSURL * pictureURL;
    NSURL * sourceURL;
    int width;
    int height;
    NSDate * createdTime;
    NSDate * updatedTime;
    NSArray * likes;
}

@property (readonly) NSString * pictureID;
@property (readonly) ANFBPerson * from;
@property (readonly) NSURL * pictureURL;
@property (readonly) NSURL * sourceURL;
@property (readonly) int width;
@property (readonly) int height;
@property (readonly) NSDate * createdTime;
@property (readonly) NSDate * updatedTime;
@property (readonly) NSArray * likes;

- (id)initWithDictionary:(NSDictionary *)pictureInfo;

@end
