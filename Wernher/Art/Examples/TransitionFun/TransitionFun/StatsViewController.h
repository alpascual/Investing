//
//  StatsViewController.h
//  Art
//
//  Created by Albert Pascual on 2/18/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

- (IBAction)menuButtonTapped:(id)sender;
@end
