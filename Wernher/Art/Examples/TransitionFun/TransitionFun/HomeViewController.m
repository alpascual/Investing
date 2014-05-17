//
//  HomeViewController.m
//  Art
//
//  Created by Albert Pascual on 2/23/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "HomeViewController.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Setting up the bar again
    //showing white status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //preventing weird inset
    [self setAutomaticallyAdjustsScrollViewInsets: NO];
    
    //navigation bar work
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1, 1)];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //self.title = @"Leonardo";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Museo500-Regular" size:20.0],
      NSFontAttributeName, nil]];
    
	
    // Bar
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//    
//    // Show/Hide bar
//    // Let say you've a bool 'shown' for current status of navbar's visibility.
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    [[UINavigationBar appearance] setAlpha:0.5f];
    
    
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ( [defaults objectForKey:@"presentation"] == nil) {
        
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PresentationStoryboardID"];        
    }
    else
    {
        [defaults removeObjectForKey:@"presentation"];

        [NSTimer scheduledTimerWithTimeInterval:0.9 target:self
                                       selector:@selector(loadingProcessFinished) userInfo:nil repeats:NO];
    }
}

- (void)loadingProcessFinished {
     self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Gallery2NavigationController"]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction) resetPresentation:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"presentation"];
    [defaults synchronize];
}

@end
