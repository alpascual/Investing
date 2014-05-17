//
//  ALGalleryViewController.m
//  Art
//
//  Created by Albert Pascual on 2/13/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "ALGalleryViewController.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

@interface ALGalleryViewController ()

@end

@implementation ALGalleryViewController

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
    self.title = @"Gallery";
    
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
    
    // ***********************
    // Get images
    self.pictures = [[ALPictures alloc] init];
    NSArray *allpictures = [self.pictures getPictures:20];
    
    // Prepare
    NSMutableArray *tutorialLayers = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<allpictures.count; i++)
    {
        NSDictionary *item = [allpictures objectAtIndex:i];
        
        //get the image and store it!
        ALPictureItem *itemPicture = [ALPictureParser parsePicture:item];
        
        // TODO connect the picture into an ICETutorial Page
        ICETutorialPage *layerTemp = [[ICETutorialPage alloc] initWithSubTitle:@"Picture"
                                                                description:itemPicture.itemID
                                                                pictureName:itemPicture.thumb];
        
        [tutorialLayers addObject:layerTemp];
    }
    
    // ***********************
    
	
    // Images
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Init the pages texts, and pictures.
//    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 1"
//                                                            description:@"Champs-Elysées by night"
//                                                            pictureName:@"tutorial_background_00@2x.jpg"];
//    
//    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 2"
//                                                            description:@"The Eiffel Tower with\n cloudy weather"
//                                                            pictureName:@"tutorial_background_01@2x.jpg"];
//   
//    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 3"
//                                                            description:@"An other famous street of Paris"
//                                                            pictureName:@"tutorial_background_02@2x.jpg"];
//   
//    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 4"
//                                                            description:@"The Eiffel Tower with a better weather"
//                                                            pictureName:@"tutorial_background_03@2x.jpg"];
//    
//    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 5"
//                                                            description:@"The Louvre's Museum Pyramide"
//                                                            pictureName:@"tutorial_background_04@2x.jpg"];
//    
    // Set the common style for SubTitles and Description (can be overrided on each page).
    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
    
    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
    [descStyle setFont:TUTORIAL_DESC_FONT];
    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    
    // Load into an array.
    //NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone"
                                                                      bundle:nil
                                                                    andPages:tutorialLayers];
    }
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
    [self.viewController setCommonPageSubTitleStyle:subStyle];
    [self.viewController setCommonPageDescriptionStyle:descStyle];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    // Set button 1 action.
    [self.viewController setButton1Block:^(UIButton *button){
        NSLog(@"Button 1 pressed.");
        
        // TODO register
        
        // Neeed work for an animation!!
        weakSelf.viewController.autoScrollEnabled = YES;
        weakSelf.viewController.autoScrollDurationOnPage = 0.1;
        [weakSelf.viewController startScrolling];
        
    }];
    
    // Set button 2 action, stop the scrolling.
    
    [self.viewController setButton2Block:^(UIButton *button){
        NSLog(@"Button 2 pressed.");
        NSLog(@"Auto-scrolling stopped.");
        
        //[weakSelf.viewController stopScrolling];
        // Neeed work for an animation!!
        weakSelf.viewController.autoScrollEnabled = YES;
        weakSelf.viewController.autoScrollDurationOnPage = 0.1;
        [weakSelf.viewController startScrolling];
    }];
    
    // Run it.
    self.viewController.autoScrollEnabled = NO;
    [self.viewController stopScrolling];
    
    
    [self.view addSubview:self.viewController.view];
    //self.window.rootViewController = self.viewController;
    //[self.window makeKeyAndVisible];
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
