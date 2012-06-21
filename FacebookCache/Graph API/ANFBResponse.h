//
//  ANFBResponse.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANFBResponse : NSObject {
    NSURLRequest * request;
    NSURLResponse * response;
    NSData * responseData;
    NSObject * jsonObject;
}

@property (readonly) NSURLRequest * request;
@property (readonly) NSURLResponse * response;
@property (readonly) NSData * responseData;
@property (readonly) NSObject * jsonObject;

- (id)initWithRequest:(NSURLRequest *)aRequest response:(NSURLResponse *)theResponse data:(NSData *)theData;

- (NSDictionary *)responseDictionary;
- (NSURL *)nextPage;
- (NSArray *)responseDataArray;

- (BOOL)isErrorMessage;
- (NSError *)responseError;

@end
