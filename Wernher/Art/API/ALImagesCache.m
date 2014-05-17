//
//  ALImagesCache.m
//  Art
//
//  Created by Albert Pascual on 3/13/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "ALImagesCache.h"

@implementation ALImagesCache

static ALImagesCache *sharedCache;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedCache = [[ALImagesCache alloc] init];
        sharedCache.images = [[NSMutableDictionary alloc] init];
    }
    
    //return sharedCache;
}

+ (ALImagesCache*)sharedCache
{
    return sharedCache;
}

- (void) addImage:(NSString*)key withData:(NSData*)data
{
    //NSLog(@"Storing image with URL %@", key);
    
    NSArray * fragments = [key componentsSeparatedByString:@"/"];
    NSString *token = [fragments objectAtIndex:fragments.count-1];
    [sharedCache.images setValue:data forKey:token];
}

- (NSData*) getCacheImageWithURL:(NSString*)key
{
    NSArray * fragments = [key componentsSeparatedByString:@"/"];
    NSString *token = [fragments objectAtIndex:fragments.count-1];
   // NSLog(@"Getting images with count %d and key %@", sharedCache.images.count, key);
    NSData *data = [sharedCache.images objectForKey:token];
    if ( data == nil)
    {
        ALPictures *pic = [[ALPictures alloc] init];
        data = [pic getImageData:key];
    }
    
    return data;
}

- (void) addList:(NSArray*)listArray
{
    if (sharedCache.cachedList == nil)
        sharedCache.cachedList = [[NSMutableArray alloc] init];
    
    [sharedCache.cachedList addObjectsFromArray:listArray];
}

- (NSArray*) getCachedList
{
    return sharedCache.cachedList;
}


@end
