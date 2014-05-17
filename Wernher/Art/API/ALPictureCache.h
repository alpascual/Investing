//
//  ALPictureCache.h
//  Art
//
//  Created by Albert Pascual on 3/8/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPictures.h"
#import "ALPictureItem.h"
#import "ALPictureParser.h"
#import "ALImagesCache.h"

@interface ALPictureCache : NSObject

- (void) generateRequestAndCacheAll;

@end
