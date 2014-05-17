//
//  ALPictureItem.h
//  Art
//
//  Created by Albert Pascual on 2/20/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPictureItem : NSObject

@property (nonatomic,strong) NSString *thumb;
@property (nonatomic,strong) NSString *itemID;
@property (nonatomic,strong) NSString *whratio;
@property (nonatomic,strong) NSString *owner;
@property (nonatomic,strong) NSString *stamp;
@property (nonatomic,strong) NSString *artist;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) BOOL liked;

@end
