//
//  SBInstagramCell.h
//  instagram
//
//  Created by Santiago Bustamante on 8/31/13.
//  Copyright (c) 2013 Pineapple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBInstagramMediaEntity.h"
#import "ALPictureItem.h"
#import "ALPictures.h"
#import "SBInstagramProtocol.h"
#import "ALImagesCache.h"
#import "AlFont.h"
#import "CellInfoViewController.h"

@interface SBInstagramCell : UICollectionViewCell<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UIImageView *imageViewThumb;
@property (strong, nonatomic) UIButton *imageButton;
@property (assign, nonatomic) SBInstagramMediaPagingEntity *entity;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL showOnePicturePerRow;
@property (nonatomic, strong) ALPictureItem *mediaArrayItem;
@property (nonatomic, strong) id<SBInstagramProtocol> delegate;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleAuthor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRight;
@property (nonatomic, strong) UIPanGestureRecognizer *panSwipe;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) BOOL bFlipped;
@property (nonatomic, strong) CellInfoViewController *infoView;

-(void)setEntity:(SBInstagramMediaPagingEntity *)entity andIndexPath:(NSIndexPath *)index;
-(void)imageWasSwiped:(UISwipeGestureRecognizer *)recognizer;
-(void)imageTapped:(UITapGestureRecognizer *)recognizer;
-(void)imagePanned:(UIPanGestureRecognizer *)recognizer;
-(void)addBanner:(ALPictureItem *)item;
-(void) finishingAnimation:(UIPanGestureRecognizer *)recognizer withPosition:(CGFloat)finalX;
- (void) snapBack:(UIPanGestureRecognizer *)recognizer;

@end
