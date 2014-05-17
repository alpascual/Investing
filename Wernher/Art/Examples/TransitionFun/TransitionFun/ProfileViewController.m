//
//  Gallery4ViewController.m
//  Art
//
//  Created by Albert Pascual on 2/27/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "ProfileViewController.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    BTGlassScrollView *_glassScrollView;
    BTGlassScrollView *_glassScrollView2;
    
    UIScrollView *_viewScroller;
    NSMutableArray *_viewsArray;
    int _page;
}

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
    
    //background
//    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Museo500-Regular" size:20.0],
      NSFontAttributeName, nil]];

    ALPictures *pictures = [[ALPictures alloc] init];
    NSString *taste = [pictures tastePin];
    NSLog(@"What's the taste");
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithJSONString:taste error:&error];
    
    [self.myStatus setText:[dic objectForKey:@"status"]];
    [self.aboutMe setText:[dic objectForKey:@"quality"]];
    // set status label
//    UILabel *status = (UILabel*)[self.view viewWithTag:1];
//    [status setText: @"Collector"];
//
//    // set aboutme label
//    UILabel *aboutme = (UILabel*)[self.view viewWithTag:2];
//    [aboutme setText: @"Eclectic"];
    
    return;
    
    // End
	
//    // Bar
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
    
    
    //********************************************
    
    CGFloat blackSideBarWidth = 2;
    
    _viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
    [_viewScroller setPagingEnabled:YES];
    [_viewScroller setDelegate:self];
    [_viewScroller setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_viewScroller];
    
    // JASON, requesting more images here will just increase the cache
//    self.pictures = [[ALPictures alloc] init];
//    NSArray *allpictures = [self.pictures getPictures:20];
//    
//    _viewsArray = [[NSMutableArray alloc] init];
//    
//    for (int i=0; i<allpictures.count; i++)
//    {
//        NSDictionary *item = [allpictures objectAtIndex:i];
//        
//        //get the image and store it!
//        ALPictureItem *itemPicture = [ALPictureParser parsePicture:item];
//        
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:itemPicture.thumb]]];
//    
//        BTGlassScrollView *glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:image blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
//        [_viewScroller addSubview:glassScrollView];
//        [_viewsArray addObject:glassScrollView];
//    }
    
    //*******************************************
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
        int page = _page; // resize scrollview can cause setContentOffset off for no reason and screw things up
        
        CGFloat blackSideBarWidth = 2;
        [_viewScroller setFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
        [_viewScroller setContentSize:CGSizeMake(3*_viewScroller.frame.size.width, self.view.frame.size.height)];
    
        for (int i=0; i < _viewsArray.count; i++) {
        
            BTGlassScrollView * glassTemp = [_viewsArray objectAtIndex:i];
            [glassTemp setFrame:self.view.frame];
        
            if ( i != 0 )
                [glassTemp setFrame:CGRectOffset(_glassScrollView2.bounds, _viewScroller.frame.size.width, 0)];
        
            [_viewScroller setContentOffset:CGPointMake(page * _viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
        }
        _page = page;
    
    
    //show animation trick
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // [_glassScrollView1 setBackgroundImage:[UIImage imageNamed:@"background"] overWriteBlur:YES animated:YES duration:1];
    });
}


- (void)viewWillLayoutSubviews
{
    // if the view has navigation bar, this is a great place to realign the top part to allow navigation controller
    // or even the status bar
    
    for (int i=0; i < _viewsArray.count; i++) {
        BTGlassScrollView * glassTemp = [_viewsArray objectAtIndex:i];
        [glassTemp setTopLayoutGuideLength:[self.topLayoutGuide length]];
        [glassTemp setTopLayoutGuideLength:[self.topLayoutGuide length]];
        [glassTemp setTopLayoutGuideLength:[self.topLayoutGuide length]];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    _page = (int)floor(ratio);
    NSLog(@"%i",_page);
    
    for (int i=0; i < _viewsArray.count; i++) {
        BTGlassScrollView * glassTemp = [_viewsArray objectAtIndex:i];
    
        if (ratio > -1 && ratio < i+1) {
            [glassTemp scrollHorizontalRatio:-ratio + i];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    BTGlassScrollView *glass = [self currentGlass];
    
    //can probably be optimized better than this
    //this is just a demonstration without optimization
    for (int i=0; i < _viewsArray.count; i++) {
        BTGlassScrollView * glassTemp = [_viewsArray objectAtIndex:i];
        [glassTemp scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
    }
}

- (BTGlassScrollView *)currentGlass
{
    BTGlassScrollView * glassTemp = [_viewsArray objectAtIndex:_page];
    return glassTemp;
}


- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 705)];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
//    [label setText:[NSString stringWithFormat:@"%i℉",arc4random_uniform(20) + 60]];
//    [label setTextColor:[UIColor whiteColor]];
//    [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
//    [label setShadowColor:[UIColor blackColor]];
//    [label setShadowOffset:CGSizeMake(1, 1)];
//    [view addSubview:label];
    
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 140, 310, 125)];
    box1.layer.cornerRadius = 3;
    box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box1];
    
    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 270, 310, 300)];
    box2.layer.cornerRadius = 3;
    box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box2];
    
    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 575, 310, 125)];
    box3.layer.cornerRadius = 3;
    box3.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box3];
    
    return view;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self viewWillAppear:YES];
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

@end
