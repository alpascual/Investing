//
//  ALGalleryViewController.h
//  Art
//
//  Created by Albert Pascual on 2/13/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICETutorialController.h"
#import "ICETutorialPage.h"

#import "ALPictures.h"
#import "ALPictureItem.h"
#import "ALPictureParser.h"

@interface ALGalleryViewController : UIViewController


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ICETutorialController *viewController;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@property (nonatomic, strong) ALPictures *pictures;

- (IBAction)menuButtonTapped:(id)sender;
@end
