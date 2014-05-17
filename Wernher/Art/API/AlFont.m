//
//  AlFont.m
//  Art
//
//  Created by Albert Pascual on 3/7/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "AlFont.h"

@implementation AlFont
+ (UIFont*) defaultFont
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    return font;
}

+ (UIFont*) titleFont
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    return font;
}

+ (UIFont*) artistNameFont
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    return font;
}

@end
