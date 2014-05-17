//
//  ALImagesCache.h
//  Art
//
//  Created by Albert Pascual on 3/13/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPictures.h"

@interface ALImagesCache : NSObject

@property (atomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSMutableArray *cachedList;

- (void) addImage:(NSString*)key withData:(NSData*)data;
- (NSData*) getCacheImageWithURL:(NSString*)key;
- (void) addList:(NSArray*)listArray;
- (NSArray*) getCachedList;
+ (ALImagesCache*)sharedCache;


@end
