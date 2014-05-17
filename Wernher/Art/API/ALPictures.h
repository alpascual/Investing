//
//  ALPictures.h
//  Art
//
//  Created by Albert Pascual on 2/19/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRepresentation.h"
#import "NSDictionary_JSONExtensions.h"
#import "UniqueIdentifier.h"
#import "ALImagesCache.h"
#import "ALPictureParser.h"
#import "ALPictureCache.h"

@interface ALPictures : NSObject

- (NSString*) tastePin;
- (BOOL) like:(NSString*)lid;
- (BOOL) dismiss:(NSString*)lid;
- (NSArray*) getPictures:(NSInteger)howMany;
- (NSArray*) getPicturesWithTime:(NSInteger)howMany timestamp:(NSInteger)stamp;
- (NSString*) makeRequest:(NSString*)requestString;
- (NSData*)getImageData:(NSString*)imageUrl;
- (void) getMorePictures:(NSInteger)howMany;

@end
