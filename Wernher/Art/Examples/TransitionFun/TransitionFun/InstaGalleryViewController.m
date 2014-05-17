//
//  InstaGalleryViewController.m
//  Art
//
//  Created by Albert Pascual on 2/21/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import "InstaGalleryViewController.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

@interface InstaGalleryViewController ()

@end

@implementation InstaGalleryViewController

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
	
//    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
//        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
//        if (!self.dynamicTransitionPanGesture) {
//            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
//        }
//        
//        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
//        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
//    } else {
//        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
//        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
//    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //here create the instagram view
    self.instagram = [SBInstagramController instagramViewController];
    
    NSLog(@"framework version: %@",self.instagram.version);
    
    //both are optional, but if you need search by tag you need set both
    self.instagram.isSearchByTag = YES; //if you want serach by tag
    self.instagram.searchTag = @"art"; //search by tag query
    
    self.instagram.showOnePicturePerRow = YES; //to change way to show the feed, one picture per row(default = NO)
    
    [self.view addSubview:self.instagram.view];
    
    
    //UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:instagram];
    
    //self.window.rootViewController = navCon;
    
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

- (IBAction)shareItem:(id)sender
{
    
    //ProfileNavigationController
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Gallery3NavigationController"];
    
//    NSString *tokenMd5 = [self md5:[UniqueIdentifier getUniqueIdentifier]];
// 
//    NSString* someText = @"I would like to share my art with you.";
//    NSString *stringUrl = [[NSString alloc] initWithFormat:@"http://dev.leonar.do/share/%@", tokenMd5];
//    NSURL* Website = [NSURL URLWithString:stringUrl];
//    NSArray* dataToShare = @[Website];//,Website];
//    
//    
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
//    
//   [self presentViewController:activityViewController animated:YES completion:nil];
//    
    
}

- (NSString *)md5:(NSString*)token
{
    const char *cStr = [token UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}


@end
