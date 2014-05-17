//
//  ALPictureParser.h
//  Art
//
//  Created by Albert Pascual on 2/20/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPictureItem.h"


@interface ALPictureParser : NSObject

+ (ALPictureItem*) parsePicture:(NSDictionary*)itemToParse;
- (void) setLastTimeStamp:(NSString*)stringStamp;
- (NSString*) getLastTimeStamp;

@end


