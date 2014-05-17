//
//  SBInstagramCollectionViewController.m
//  instagram
//
//  Created by Santiago Bustamante on 8/31/13.
//  Copyright (c) 2013 Pineapple Inc. All rights reserved.
//

#import "SBInstagramCollectionViewController.h"
#import "SBInstagramController.h"
#import "SBInstagramMediaEntity.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

@interface SBInstagramCollectionViewController()

@property (nonatomic, strong) NSMutableArray *mediaArray;
@property (nonatomic, strong) SBInstagramController *instagramController;
@property (nonatomic, assign) BOOL downloading;
@property (nonatomic, assign) BOOL hideFooter;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation SBInstagramCollectionViewController

-(NSString *)version{
    return @"1.4";
}

- (id) initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    if ((self = [super initWithCollectionViewLayout:layout])) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicator startAnimating];
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture) {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    //**************************
    
    
    self.title = @"Art Images";
    self.downloading = YES;
    self.hideFooter = NO;
    
    [self.collectionView registerClass:[SBInstagramCell class] forCellWithReuseIdentifier:@"SBInstagramCell"];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
   
    
    // ***********************
    // Get images
    [self buildItems];
    // ***********************
    
}

- (void) buildItems
{
    self.mediaArray = [NSMutableArray arrayWithCapacity:0];
    // Get images
    self.pictures = [[ALPictures alloc] init];
    NSArray *allpictures = [self.pictures getPictures:50]; // TODO change it to 50
    
    for (int i=0; i<allpictures.count; i++)
    {
        NSDictionary *item = [allpictures objectAtIndex:i];
        
        //get the image and store it!
        ALPictureItem *itemPicture = [ALPictureParser parsePicture:item];
        
        [self.mediaArray addObject:itemPicture];
    }
}

- (void) buildMoreItems
{
    self.pictures = [[ALPictures alloc] init];
    [self.pictures getMorePictures:20];    
}


-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void) downloadNext{
    self.downloading = YES;
    if ([self.mediaArray count] == 0) {
        [self.instagramController mediaUserWithUserId:INSTAGRAM_USER_ID andBlock:^(NSArray *mediaArray, NSError *error) {
            if (error || mediaArray.count == 0) {
                SB_showAlert(@"Instagram", @"No results found", @"OK");
                [self.activityIndicator stopAnimating];
            }else{
                [self.mediaArray addObjectsFromArray:mediaArray];
                [self.collectionView reloadData];
            }
            self.downloading = NO;
            
        }];
    }else{
        [self.instagramController mediaUserWithPagingEntity:[self.mediaArray objectAtIndex:(self.mediaArray.count-1)] andBlock:^(NSArray *mediaArray, NSError *error) {
            
            NSUInteger a = [self.mediaArray count];
            [self.mediaArray addObjectsFromArray:mediaArray];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            [mediaArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSUInteger b = a+idx;
                NSIndexPath *path = [NSIndexPath indexPathForItem:b inSection:0];
                [arr addObject:path];
            }];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:arr];
            } completion:nil];
            
            self.downloading = NO;
            
            if (mediaArray.count == 0) {
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                self.hideFooter = NO;
                [self.collectionView reloadData];
            }
            
        }];
    }    
    
}


- (void) setShowOnePicturePerRow:(BOOL)showOnePicturePerRow{
    BOOL reload = NO;
    if (_showOnePicturePerRow != showOnePicturePerRow) {
        reload = YES;
    }
    _showOnePicturePerRow = showOnePicturePerRow;
    if (reload) {
        [self.collectionView reloadData];
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.mediaArray count];
}



///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // HACK time: destroy old cell
    /*if (self.oldCells != nil) {
        if ( self.oldCells.count > 2) {
            for (int i=0; i < self.oldCells.count-2; i++) {
                SBInstagramCell *oldcell = [self.oldCells objectAtIndex:i];
                NSLog(@"\nOld cell %f for %d title %@", oldcell.toolbar.center.y, i, oldcell.titleLabel.text);
                if ( oldcell.toolbar.hidden == NO) {
                    oldcell.toolbar.hidden = YES;
                    oldcell.titleLabel.hidden = YES;
                    oldcell.titleAuthor.hidden = YES;
                    oldcell.imageViewThumb.hidden = YES;
                    oldcell.imageView.hidden = YES;
                    
                    [oldcell.toolbar removeFromSuperview];
                    [oldcell.titleLabel removeFromSuperview];
                    [oldcell.titleAuthor removeFromSuperview];
                    [oldcell.imageViewThumb removeFromSuperview];
                    [oldcell.imageView removeFromSuperview];
                    
                }
            }
        }
    }*/
    
    //BIG HACK!! To do not reuse Cells, won't do a good performance, yet will make sure does not reuse the cells
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    [self.collectionView registerClass:[SBInstagramCell class] forCellWithReuseIdentifier:uuidString];
    SBInstagramCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:uuidString forIndexPath:indexPath];
        
    if ( self.mediaArray == nil )
    {
        NSLog(@"rebuild");
        [self buildItems];
    }
    
    //NSLog(@"Row %ld and media count %lu", (long)indexPath.row, (unsigned long)self.mediaArray.count);
    
    ALPictureItem *item = [self.mediaArray objectAtIndex:indexPath.row];
    cell.mediaArrayItem = item;
    cell.tag =indexPath.row;
    cell.delegate = self;

    if ([self.mediaArray count]>0) {
        SBInstagramMediaPagingEntity *entity = [self.mediaArray objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        cell.showOnePicturePerRow = self.showOnePicturePerRow;
        [cell setEntity:entity andIndexPath:indexPath];

    }
    
    if (indexPath.row == [self.mediaArray count]-1 && !self.downloading) {
        [self downloadNext];
    }
    
    if (indexPath.row == [self.mediaArray count]-5)
    {
        // TODO download more pictures
    }
    
    // Set the old cell
    /*if ( self.oldCells == nil)
        self.oldCells = [[NSMutableArray alloc] init];
    
    [self.oldCells addObject:cell];*/
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.hideFooter) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(self.view.frame),40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
//    if (kind != UICollectionElementKindSectionFooter || self.hideFooter){
//        return nil;
//    }
//    
//    UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
//    
//    CGPoint center = self.activityIndicator.center;
//    center.x = foot.center.x;
//    center.y = 20;
//    self.activityIndicator.center = center;
//    
//    [foot addSubview:self.activityIndicator];
//    
//    return foot;
    
    
    
    
    if (kind != UICollectionElementKindSectionFooter || self.hideFooter){
        return nil;
    }
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
    
    CGPoint center = self.activityIndicator.center;
    center.x = foot.center.x;
    center.y = 20;
    self.activityIndicator.center = center;
    
    [foot addSubview:self.activityIndicator];
    
    
    // TODO, here fetch more images
    [self buildMoreItems];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                   selector:@selector(finishFooter) userInfo:nil repeats:NO];
    
    return foot;
}

- (void)finishFooter {
    
    NSLog(@"Count in media array %lu", (unsigned long)self.mediaArray.count);
    NSArray *listToAddTemp = [[ALImagesCache sharedCache] getCachedList];
    
    NSMutableArray *listToAdd = [[NSMutableArray alloc] init];
    for (int t=0; t < 40; t++) {
        [listToAdd addObject:[listToAddTemp objectAtIndex:t]];
    }
    
    for (int i=0; i<listToAdd.count; i++) {
        ALPictureItem *item =[listToAdd objectAtIndex:i];
        [self.mediaArray addObject:item];
    }
    //[self.mediaArray addObjectsFromArray:listToAdd];
    NSLog(@"Count in media array After %lu", (unsigned long)self.mediaArray.count);
    
    NSMutableArray *toAdd = [[NSMutableArray alloc] init];
    
    NSInteger iStarting = self.mediaArray.count-listToAdd.count;
    for( int i=iStarting; i < self.mediaArray.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //[indexPath addObject:[self.mediaArray objectAtIndex:i] inSection:0]];
        //[toAdd addObject:[self.mediaArray objectAtIndex:i]];
        [toAdd addObject:indexPath];
        NSLog(@"Temp log item at %d", i);
    }
    
    [self.collectionView insertItemsAtIndexPaths:toAdd];
    //[self.collectionView reloadData];

}


///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // problem is reusing cells?
    
    // This one is the size of the cell
    
    NSInteger pos = indexPath.row;
    ALPictureItem *item = [self.mediaArray objectAtIndex:pos];
    
    //NSLog(@"Item info %@ on position %d", item, pos);
    
    float ratio = 1;
    
    @try {
        if ( item.whratio != nil )
            ratio = [item.whratio doubleValue];
    }
    @catch (NSException *exception) {
        NSLog(@"Item ERROR %@", item);
        item = [ALPictureParser parsePicture:(NSDictionary*)item];
        ratio = [item.whratio doubleValue];
    }
    @finally {
        
    }
    
    
    float height = 325 / ratio;
    //float height = 325;
    NSLog(@"-------Height of the cell %f----", height);
    
    return CGSizeMake(320, height);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.showOnePicturePerRow) {
        return 0;
    }
    return 10* (SB_IS_IPAD?2:1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.showOnePicturePerRow) {
        return 0;
    }
    return 10 * (SB_IS_IPAD?2:1);
}

#pragma mark - IBActions

//- (IBAction)menuButtonTapped:(id)sender {
//    [self.slidingViewController anchorTopViewToRightAnimated:YES];
//}


- (void) cellDeleted:(ALPictureItem*)item
{
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for( int i=0; i < self.mediaArray.count; i++)
    {
        ALPictureItem *tempItem = [self.mediaArray objectAtIndex:i];
        if ( tempItem.itemID == item.itemID )
        {
            [self.mediaArray removeObjectAtIndex:i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [toDelete addObject:indexPath];
            break;
        }
    }
    
    [self.collectionView deleteItemsAtIndexPaths:toDelete];
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

@end
