//
//  ANFBPerson.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: add all of the other user fields
@interface ANFBPerson : NSObject {
    NSString * userID;
    NSString * name;
    NSString * username;
}

@property (readonly) NSString * userID;
@property (readonly) NSString * name;
@property (readonly) NSString * username;

- (id)initWithUserObject:(NSDictionary *)userObject;

@end
