//
//  NSDate+Facebook.m
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Facebook.h"

@implementation NSDate (Facebook)

+ (NSDate *)dateByParsingFacebookDate:(NSString *)dateString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    return [formatter dateFromString:dateString];
}

@end
