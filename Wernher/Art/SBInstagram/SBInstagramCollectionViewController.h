//
//  SBInstagramCollectionViewController.h
//  instagram
//
//  Created by Santiago Bustamante on 8/31/13.
//  Copyright (c) 2013 Pineapple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBInstagramCell.h"
#import "ALPictures.h"
#import "ALPictureItem.h"
#import "ALPictureParser.h"
#import "SBInstagramProtocol.h"

#define SB_IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define SB_showAlert(Title, Message, CancelButton) UIAlertView * alert = [[UIAlertView alloc] initWithTitle:Title message:Message delegate:nil cancelButtonTitle:CancelButton otherButtonTitles:nil, nil]; \
[alert show];



@interface SBInstagramCollectionViewController : UICollectionViewController <SBInstagramProtocol>

@property (nonatomic, readonly) NSString *version;

@property (nonatomic, assign) BOOL isSearchByTag;
@property (nonatomic, strong) NSString *searchTag;

@property (nonatomic, assign) BOOL showOnePicturePerRow;
@property (strong, nonatomic) ALPictures *pictures;

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) NSMutableArray *oldCells;

- (void) buildItems;
- (void) buildMoreItems;

@end
