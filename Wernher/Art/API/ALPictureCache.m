//
//  ALPictureCache.m
//  Art
//
//  Created by Albert Pascual on 3/8/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "ALPictureCache.h"

@implementation ALPictureCache

- (void) generateRequestAndCacheAll
{
    //return;
    
    
    ALPictures *requestLots = [[ALPictures alloc] init];
    dispatch_queue_t builder = dispatch_queue_create("builder", NULL);
    dispatch_async(builder,
                   ^{
                       NSArray *lot = [[NSArray alloc] init];
                       lot = [requestLots getPictures:40];
                       [[ALImagesCache sharedCache] addList:lot];
                       
                       for(int i=0; i < lot.count; i++) {
                          
                               NSDictionary *item = [lot objectAtIndex:i];
                           
                               // AL Bookmark
                               //get the image and store it!
                               ALPictureItem *itemPicture = [ALPictureParser parsePicture:item];
                               
                               // Request the image and get the data
                               ALPictures *pic = [[ALPictures alloc] init];
                               NSData *dataForPic = [pic getImageData:itemPicture.thumb];
                               
                               //NSLog(@"Adding image for URL %@", itemPicture.thumb);
                               [[ALImagesCache sharedCache] addImage:itemPicture.thumb withData:dataForPic];
                           
                           
                       }
                       
                       
                   });

                       
    
    //dispatch_main();
    
    
    //TODO add it into a global array
    
}



@end
