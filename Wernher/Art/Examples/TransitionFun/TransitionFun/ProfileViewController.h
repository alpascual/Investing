//
//  Gallery4ViewController.h
//  Art
//
//  Created by Albert Pascual on 2/27/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGlassScrollView.h"
#import "ALPictures.h"
#import "ALPictureItem.h"
#import "ALPictureParser.h"

@interface ProfileViewController : UIViewController<UIScrollViewAccessibilityDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) ALPictures *pictures;
@property (nonatomic, strong) IBOutlet UILabel *myStatus;
@property (nonatomic, strong) IBOutlet UILabel *aboutMe;

- (IBAction)menuButtonTapped:(id)sender;
- (UIView *)customView;

@end
