//
//  InstaGalleryViewController.h
//  Art
//
//  Created by Albert Pascual on 2/21/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h> 
#import "SBInstagramCollectionViewController.h"
#import "SBInstagramController.h"
#import "ALPictures.h"


@interface InstaGalleryViewController : UIViewController

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SBInstagramCollectionViewController *instagram;


- (IBAction)menuButtonTapped:(id)sender;
- (NSString *)md5:(NSString*)token;

@end
