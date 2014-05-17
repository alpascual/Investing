//
//  SBInstagramCell.m
//  instagram
//
//  Created by Santiago Bustamante on 8/31/13.
//  Copyright (c) 2013 Pineapple Inc. All rights reserved.
//

#import "SBInstagramCell.h"
#import "SBInstagramImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SBInstagramCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

    }
    return self;
}

-(void)setEntity:(SBInstagramMediaPagingEntity *)entity andIndexPath:(NSIndexPath *)index{
    
    [self setupCell];
    
    // State if they have flipped the image
    self.bFlipped = NO;
    
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"InstagramLoading.png"] forState:UIControlStateNormal];
    _entity = entity;
    
    ALPictureItem *item = (ALPictureItem*)entity;
    //NSLog(@"item debug %@", item);
    
    self.imageButton.userInteractionEnabled = !self.showOnePicturePerRow;
    self.imageButton.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    
    if (self.showOnePicturePerRow) {
        
        
        //NSLog(@"item %@", item);
        // HERE we download
        
        NSString *thumb;
        
        @try {
            thumb = item.thumb;
        }
        @catch (NSException *exception) {
            item = [ALPictureParser parsePicture:(NSDictionary*)item];
            thumb = item.thumb;
        }
        @finally {
            
        }
        
       
        
        self.image = [UIImage imageWithData:[[ALImagesCache sharedCache] getCacheImageWithURL:thumb]];
        if ( self.image == nil)
        {
            self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumb]]];
        }
        
        //Gestures
        self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasSwiped:)];
        self.swipeLeft.numberOfTouchesRequired = 1;
        self.swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        
        self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageWasSwiped:)];
        self.swipeRight.numberOfTouchesRequired = 1;
        self.swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        
        self.panSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanned:)];
        self.panSwipe.minimumNumberOfTouches = 1;
        self.panSwipe.maximumNumberOfTouches = 1;
        [self.panSwipe setCancelsTouchesInView:NO];
        self.panSwipe.delaysTouchesBegan = YES;
        self.panSwipe.delegate = self;
        
        // Implement double tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 2;
        
        // Implement sigle tap to show details
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTapped:)];
        singleTap.numberOfTouchesRequired = 1;
        singleTap.numberOfTapsRequired = 1;
        
        [singleTap requireGestureRecognizerToFail : tap];
       
        [self.imageButton setBackgroundImage:self.image forState:UIControlStateNormal];
        
        // Set the height of the button TODO fix this
        float ratio = [item.whratio doubleValue];
        self.contentView.frame = CGRectMake(self.contentView.bounds.origin.x, self.contentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height / ratio);
        
        self.originalFrame = self.contentView.frame;
        //NSLog(@"Original Frame %@", self.originalFrame);
         
        [self.contentView addSubview:self.userImage];
        
        [self.contentView addGestureRecognizer:self.panSwipe];
        [self.contentView addGestureRecognizer:tap];
       
        
        // remove single tap/flip for now... until we have content for it
        // JASON: if you comment out this line the tap and hold won;t have delegate and
        // Will crash the app
        [self.contentView addGestureRecognizer:singleTap];
        
        
        // Add animation for the toolbar
        // TODO Enable animation soon with
        
        [self addBanner:item];
        

        
    }else{
        [self.userImage removeFromSuperview];
        [self.toolbar removeFromSuperview];
        [self.imageViewThumb removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.titleAuthor removeFromSuperview];
    }
    
    
}


- (void)addBanner:(ALPictureItem *)item
{
    // Add banner image
    CGRect rect = CGRectMake(0, self.bounds.origin.y + self.bounds.size.height-50, self.bounds.size.width, 50.0f);
    
    // create the toolbar, add to cell
    _toolbar = [[UIToolbar alloc]initWithFrame:rect];
    _toolbar.barTintColor = [UIColor blackColor];
    [_toolbar setTranslucent:YES];
    _toolbar.alpha = 0.33;
    
    // add toolbar and constraints
    [self.contentView addSubview:_toolbar];
//    [_toolbar setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    [self.contentView addConstraint: [NSLayoutConstraint
//                              constraintWithItem:_toolbar
//                              attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0
//                              constant:0]];
//    
//    [self.contentView addConstraint: [NSLayoutConstraint
//                                      constraintWithItem:_toolbar
//                                      attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0
//                                      constant:0]];
//    
//    [self.contentView addConstraint: [NSLayoutConstraint
//                                      constraintWithItem:_toolbar
//                                      attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0
//                                      constant:-50]];
    
    
    
    
    // add 'like' images to toolbar
    NSString *filePathThumb = [[NSBundle mainBundle] pathForResource:@"heart-black" ofType:@"png"];
    if ( item.liked == YES )
        filePathThumb = [[NSBundle mainBundle] pathForResource:@"heart-white" ofType:@"png"];
    NSData *myDataThumb = [NSData dataWithContentsOfFile:filePathThumb];
    
    // add like image
    UIImage *imageThumb =[[UIImage alloc] initWithData:myDataThumb];
    _imageViewThumb = [[UIImageView alloc] initWithImage:imageThumb];
    
    // single-tap "like" icon
    _imageViewThumb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapImage.numberOfTouchesRequired = 1;
    tapImage.numberOfTapsRequired = 1;
    [_imageViewThumb addGestureRecognizer:tapImage];

    
    // add _imageViewThumb and contraints
    //
    [_toolbar addSubview:_imageViewThumb];
    [_imageViewThumb setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_toolbar addConstraint: [NSLayoutConstraint
                                      constraintWithItem:_imageViewThumb
                                      attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_toolbar attribute:NSLayoutAttributeRight multiplier:1.0
                                      constant:-8]];
    
    [_toolbar addConstraint: [NSLayoutConstraint
                              constraintWithItem:_imageViewThumb
                              attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_toolbar attribute:NSLayoutAttributeCenterY multiplier:1.0
                              constant:0]];
    
    
    // Add item label Title
    CGRect rectTitle = CGRectMake(10, self.bounds.origin.y + self.bounds.size.height-60, self.bounds.size.width, 50.0f);
    _titleLabel = [[UILabel alloc] initWithFrame:rectTitle];
    _titleLabel.font = [AlFont titleFont];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = (item.title.length == 0) ? @"" : item.title;
    
    [self.contentView addSubview:_titleLabel];
    
    // Add item label Artist
    CGRect rectAuthor = CGRectMake(10, self.bounds.origin.y + self.bounds.size.height-40, self.bounds.size.width, 50.0f);
    _titleAuthor = [[UILabel alloc] initWithFrame:rectAuthor];
    _titleAuthor.font = [AlFont artistNameFont];
    _titleAuthor.textColor = [UIColor whiteColor];
    _titleAuthor.text = (item.artist.length == 0) ? @"" : item.artist;
    
    [self.contentView addSubview:_titleAuthor];
   
    // set alpha for items in the toolbar
    _titleAuthor.alpha = 0.9;
    _titleLabel.alpha = 0.9;
    _imageViewThumb.alpha = 0.5;
    
}

- (void) imageSingleTapped:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Single Tapped");
    
    // I like UIViewAnimationOptionTransitionFlipFromBottom
    [UIView transitionWithView:self.contentView duration:0.40 options:(UIViewAnimationOptionTransitionFlipFromRight) animations:^{
        
        if ( self.bFlipped == NO) {
            
            self.infoView = [[CellInfoViewController alloc] initWithNibName:@"CellInfoViewController" bundle:nil];
            [self.contentView addSubview:self.infoView.view];
            
            self.bFlipped = YES;
        }
        else
        {
            self.bFlipped = NO;
            [self.infoView removeFromParentViewController];
            [self.infoView.view removeFromSuperview];
        }
        
    } completion:^(BOOL finished) {
        
       
    }];
    
}

-(void)imageTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.contentView];
    
    NSString *resouceImage = @"heart-white";
    if ( self.mediaArrayItem.liked == YES)
        resouceImage = @"heart-black";
    
    NSLog(@"like tapped %@", resouceImage);
    
    [UIView animateWithDuration:1.0 animations:^{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resouceImage ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    if (myData) {
        // do something useful
    
        UIImage *image = [[UIImage alloc] initWithData:myData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = location;
        CGRect rect = imageView.frame;
        rect.size.height = 480;
        rect.size.width = 320;
        imageView.frame = rect;
        imageView.alpha = 0.0;
        imageView.frame = CGRectMake(location.x, location.y, 36, 42);
        [self.contentView addSubview:imageView];
    
        [self.imageViewThumb setImage:image];
    }
    
    }];
    
    if ( self.mediaArrayItem.liked == YES)
    {
        // Unlike the picture
        ALPictures *rest = [[ALPictures alloc] init];
        [rest dismiss:self.mediaArrayItem.itemID];
        
        self.mediaArrayItem.liked = NO;
        
        // Remove the cell
        //[self.delegate cellDeleted:self.mediaArrayItem];
    }
    else
    {
        ALPictures *rest = [[ALPictures alloc] init];
        [rest like:self.mediaArrayItem.itemID];
        
        self.mediaArrayItem.liked = YES;
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint velocity =[recognizer velocityInView:self];
    //NSLog(@"velocity x %f", velocity.x);
    if(abs(velocity.y)>=(abs(velocity.x))){
        return NO;
    }
    else
        return YES;
}

-(void)imagePanned:(UIPanGestureRecognizer *)recognizer
{
    [self.contentView bringSubviewToFront:[(UIPanGestureRecognizer*)recognizer view]];
    CGPoint translatedPoint = [recognizer translationInView:self.contentView];
    
    CGFloat firstX;// = self.contentView.bounds.origin.x;
   
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        firstX = self.contentView.bounds.origin.x;
    }

    CGRect newRect = CGRectMake(firstX-translatedPoint.x, self.contentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
    //[[recognizer view] setCenter:translatedPoint];
    [[recognizer view] setBounds:newRect];
    
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        CGFloat velocityX = (0.2*[recognizer velocityInView:self.contentView].x);
        CGFloat finalX = translatedPoint.x;// + velocityX;
//        NSLog(@"Animation Ended %f", finalX);
        
//        CGFloat newx = self.contentView.center.x + finalX;
//        CGFloat xmax = self.contentView.bounds.size.width - 10;
//        CGFloat xmin = 10;
//        CGFloat width = self.contentView.bounds.size.width;
        
//        NSLog(@"velocityx = %f", velocityX);
//        NSLog(@"finalx = %f", finalX);
//        NSLog(@"width = %f", width);
//        NSLog(@"newx = %f", newx);
        
        if ( finalX < 180 && finalX > 0) {
            //[self.contentView setBounds:self.contentView.bounds];
            [self snapBack:recognizer];
            return;
        }
        
        if ( finalX < 0 && finalX > -170) {
            //[self.contentView setBounds:self.contentView.bounds];
            [self snapBack:recognizer];
            return;
        }
        
        [self finishingAnimation:recognizer withPosition:finalX];
        
        return;
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        //NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        
        CGRect newRect = CGRectMake(firstX, self.contentView.bounds.origin.y, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        [[recognizer view] setBounds:newRect];
        [UIView commitAnimations];
        
        
        // New Stuff Need animation here instead of just deleting TODO
        [self.toolbar removeFromSuperview];
        [self.titleAuthor removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.imageViewThumb removeFromSuperview];
        [self.delegate cellDeleted:self.mediaArrayItem];
        
        //http://dev.leonar.do/api/v1/art/pins/dismissed/?lid=1234
        ALPictures *rest = [[ALPictures alloc] init];
        [rest dismiss:self.mediaArrayItem.itemID];
    }
}

- (void) snapBack:(UIPanGestureRecognizer *)recognizer
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [[recognizer view] setBounds:self.originalFrame];
    }
                     completion:^(BOOL finished) {
                        
                     }];
    
}

- (void) finishingAnimation:(UIPanGestureRecognizer *)recognizer withPosition:(CGFloat)finalX
{
    // OLD animation
    SBInstagramCell *imageView = (SBInstagramCell *)[recognizer view];
    
    CGPoint location = [recognizer locationInView:self.contentView];
	//[self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    if (finalX < 0) {
        location.x -= 420.0;
        location.y = self.contentView.center.y;
    }
    else {
        location.x += 420.0;
        location.y = self.contentView.center.y;
    }
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        imageView.alpha = 0.0;
        imageView.center = location;
    }completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"Animation finished");
            
            [_imageButton setFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 0)];
            [_userImage setFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 0)];
            
            CGRect newFrame = self.bounds;
            newFrame.size.height = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.bounds = newFrame;
            }];
            
            [self.toolbar removeFromSuperview];
            [self.titleAuthor removeFromSuperview];
            [self.titleLabel removeFromSuperview];
            [self.imageViewThumb removeFromSuperview];
            [self.delegate cellDeleted:self.mediaArrayItem];
            
        }
    }];
    
    // Animate the toolbar and labels
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.toolbar.alpha = 0.0;
        self.titleLabel.alpha = 0.0;
        self.titleAuthor.alpha = 0.0;
        self.imageViewThumb.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            //NSLog(@"Animation finished");
            
            self.toolbar.hidden = YES;
            self.titleLabel.hidden = YES;
            self.titleAuthor.hidden = YES;
            self.imageViewThumb.hidden = YES;
            
        }
    }];
    
    
    //http://dev.leonar.do/api/v1/art/pins/dismissed/?lid=1234
    ALPictures *rest = [[ALPictures alloc] init];
    [rest dismiss:self.mediaArrayItem.itemID];
}

-(void)imageWasSwiped:(UISwipeGestureRecognizer *)recognizer
{
    [self.contentView removeGestureRecognizer:self.swipeLeft];
    [self.contentView removeGestureRecognizer:self.swipeRight];
    [self.contentView addGestureRecognizer:self.panSwipe];
    
    return;
    
    // OLD animation
    SBInstagramCell *imageView = (SBInstagramCell *)[recognizer view];
    
    CGPoint location = [recognizer locationInView:self.contentView];
	//[self drawImageForGestureRecognizer:recognizer atPoint:location];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 420.0;
    }
    else {
        location.x += 420.0;
    }
    
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        imageView.alpha = 0.0;
        imageView.center = location;
    }completion:^(BOOL finished) {
                         if (finished) {
                             //NSLog(@"Animation finished");
                             
                             [_imageButton setFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 0)];
                             [_userImage setFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, 0)];
                             
                             CGRect newFrame = self.bounds;
                             newFrame.size.height = 0;
                             [UIView animateWithDuration:0.9 animations:^{
                                 self.bounds = newFrame;
                             }];
                             
                             [self.toolbar removeFromSuperview];
                             [self.titleAuthor removeFromSuperview];
                             [self.titleLabel removeFromSuperview];
                             [self.imageViewThumb removeFromSuperview];
                             [self.delegate cellDeleted:self.mediaArrayItem];
                             
                         }
                     }];
    
    // Animate the toolbar and labels
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.toolbar.alpha = 0.0;
        self.titleLabel.alpha = 0.0;
        self.titleAuthor.alpha = 0.0;
        self.imageViewThumb.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            //NSLog(@"Animation finished");
            
            self.toolbar.hidden = YES;
            self.titleLabel.hidden = YES;
            self.titleAuthor.hidden = YES;
            self.imageViewThumb.hidden = YES;
            
        }
    }];

  
    //http://dev.leonar.do/api/v1/art/pins/dismissed/?lid=1234
    ALPictures *rest = [[ALPictures alloc] init];
    [rest dismiss:self.mediaArrayItem.itemID];
    
 
}

-(void) selectedImage:(id)selector{
    
    UIViewController *viewCon = (UIViewController *)self.nextResponder;
    
    while (![viewCon isKindOfClass:[UINavigationController class]]) {
        viewCon = (UIViewController *)viewCon.nextResponder;
    }
    
    SBInstagramImageViewController *img = [SBInstagramImageViewController imageViewerWithEntity:self.entity.mediaEntity];
    
    [((UINavigationController *)viewCon) pushViewController:img animated:YES];
    
}

- (void) setupCell{
    
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [_imageButton setFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height-5)];
    [_imageButton addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"InstagramLoading.png"] forState:UIControlStateNormal];
    _imageButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageButton];
    
    if (!_userImage) {
        _userImage = [[UIImageView alloc] init];
    }
    _userImage.frame = CGRectMake(0, 0, 35, 35);
    _userImage.contentMode = UIViewContentModeScaleAspectFit;
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 17.5;
}


@end
