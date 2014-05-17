//
//  ALAccountViewController.h
//  Art
//
//  Created by Albert Pascual on 2/15/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniqueIdentifier.h"

@interface ALAccountViewController : UIViewController

@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) IBOutlet UILabel *uniqueIdentifier;

- (IBAction)menuButtonTapped:(id)sender;

@end
