//
//  ANFBAlbum.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANFBPerson.h"
#import "NSDate+Facebook.h"

@interface ANFBAlbum : NSObject {
    NSString * albumID;
    ANFBPerson * from;
    NSString * name;
    NSString * description;
    NSDate * createdTime;
    NSDate * updatedTime;
}

@property (readonly) NSString * albumID;
@property (readonly) ANFBPerson * from;
@property (readonly) NSString * name;
@property (readonly) NSString * description;
@property (readonly) NSDate * createdTime;
@property (readonly) NSDate * updatedTime;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
