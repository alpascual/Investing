//
//  NDCollectionViewFlowLayout.m
//  Art
//
//  Created by Albert Pascual on 3/17/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "NDCollectionViewFlowLayout.h"


@implementation NDCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributes = [NSMutableArray arrayWithCapacity:attributes.count];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if ((attribute.frame.origin.x + attribute.frame.size.width <= self.collectionViewContentSize.width) &&
            (attribute.frame.origin.y + attribute.frame.size.height <= self.collectionViewContentSize.height)) {
            [newAttributes addObject:attribute];
        }
    }
    return newAttributes;
}

@end
