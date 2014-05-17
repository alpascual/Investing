//
//  SBInstagramProtocol.h
//  Art
//
//  Created by Albert Pascual on 3/2/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALPictureItem.h"
//#import "SBInstagramCell.h"


@protocol SBInstagramProtocol <NSObject>

- (void) cellDeleted:(ALPictureItem*)item;

@end
