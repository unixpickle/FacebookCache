//
//  NSDate+Facebook.h
//  FacebookCache
//
//  Created by Alex Nichol on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Facebook)

+ (NSDate *)dateByParsingFacebookDate:(NSString *)dateString;

@end
