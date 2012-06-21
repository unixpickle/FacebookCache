//
//  NSDictionary+HTTPParams.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+HTTPParams.h"

@implementation NSDictionary (HTTPParams)

+ (NSDictionary *)dictionaryFromHTTPParameters:(NSString *)params {
    NSArray * components = [params componentsSeparatedByString:@"&"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString * param in components) {
        NSArray * parts = [param componentsSeparatedByString:@"="];
        if ([parts count] != 2) return nil;
        NSString * key = [parts objectAtIndex:0];
        NSString * value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:value forKey:key];
    }
    return dict;
}

+ (NSDictionary *)dictionaryFromURLParameters:(NSURL *)url {
    NSString * urlStr = [url absoluteString];
    NSRange qRange = [urlStr rangeOfString:@"?"];
    if (qRange.location != NSNotFound) {
        NSString * paramString = [urlStr substringFromIndex:(qRange.location + 1)];
        return [self dictionaryFromHTTPParameters:paramString];        
    } else {
        return [NSDictionary dictionary];
    }
}

@end
