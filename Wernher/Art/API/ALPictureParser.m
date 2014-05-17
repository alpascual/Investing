//
//  ALPictureParser.m
//  Art
//
//  Created by Albert Pascual on 2/20/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "ALPictureParser.h"

@implementation ALPictureParser

+ (ALPictureItem*) parsePicture:(NSDictionary*)itemToParse
{
    ALPictureItem *item = [[ALPictureItem alloc] init];
    item.stamp = [itemToParse objectForKey:@"stamp"];
    item.thumb = [itemToParse objectForKey:@"thumb"];
    item.itemID = [itemToParse objectForKey:@"id"];
    item.whratio = [itemToParse objectForKey:@"whratio"];
    item.owner = [itemToParse objectForKey:@"owner"];
    item.artist = [itemToParse objectForKey:@"artist"];
    item.title = [itemToParse objectForKey:@"title"];
    item.liked = NO; // Jason will give me that one soon
    
    if ( item != nil && item.stamp != nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:item.stamp forKey:@"stamp"];
        [defaults synchronize];
    }
    
    return item;
}

- (void) setLastTimeStamp:(NSString*)stringStamp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:stringStamp forKey:@"stamp"];
    [defaults synchronize];
}

- (NSString*) getLastTimeStamp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"stamp"];
}

- (id)init
{
    if ((self = [super init]) != NULL)
    {
    }
    return(self);
}


@end
