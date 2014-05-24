//
//  AboutViewController.h
//  Wernher
//
//  Created by Albert Pascual on 5/24/14.
//
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

- (IBAction)menuButtonTapped:(id)sender;

@end
