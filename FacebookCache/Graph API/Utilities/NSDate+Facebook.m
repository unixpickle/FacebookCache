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
    NSDateFormatter * formatter = [[NSDateFormatter alloc] initWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+ZZZZ" allowNaturalLanguage:NO];
    return [formatter dateFromString:dateString];
}

@end
