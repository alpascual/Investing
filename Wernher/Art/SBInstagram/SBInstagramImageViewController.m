//
//  SBInstagramImageViewController.m
//  MedellinHipHop
//
//  Created by Santiago Bustamante on 9/2/13.
//  Copyright (c) 2013 Pineapple Inc. All rights reserved.
//

#import "SBInstagramImageViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

@interface SBInstagramImageViewController ()

@end

@implementation SBInstagramImageViewController


+ (id) imageViewerWithEntity:(SBInstagramMediaEntity *)entity{
    SBInstagramImageViewController *instance = [[SBInstagramImageViewController alloc] initWithNibName:@"SBInstagramImageViewController" bundle:nil];
    instance.entity = entity;
    return instance;
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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGRect frame = self.imageView.bounds;
    frame.origin = CGPointZero;
    frame.size = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] applicationFrame]), CGRectGetWidth([[UIScreen mainScreen] applicationFrame]));
    [self.imageView setFrame:frame];
    
    frame = self.containerView.frame;
    //frame.size.height = CGRectGetHeight(self.imageView.frame) + CGRectGetHeight(self.captionLabel.frame);
    self.containerView.frame = frame;
    self.containerView.center = self.view.center;

    self.title = @"";
    
    SBInstagramImageEntity *picEntity = self.entity.images[@"standard_resolution"];
    
    [SBInstagramModel downloadImageWithUrl:picEntity.url andBlock:^(UIImage *image, NSError *error) {
        [self.activityIndicator stopAnimating];
        if (image && !error) {
            [self.imageView setImage:image];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something is wrong" message:@"Please check your Internet connection and try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    //self.captionLabel.text = self.entity.caption;
    //frame = self.captionLabel.frame;
    frame.size.width = CGRectGetWidth([[UIScreen mainScreen] applicationFrame]);
    frame.origin.y = CGRectGetMaxY(self.imageView.frame);
    //self.captionLabel.frame = frame;
    
    self.activityIndicator.center = self.imageView.center;
    
    self.userImage = [[UIImageView alloc] init];
    self.userImage.frame = CGRectMake(CGRectGetMinX(self.imageView.frame) + 10, CGRectGetMinY(self.imageView.frame) - 45, 35, 35);
    self.userImage.contentMode = UIViewContentModeScaleAspectFit;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 17.5;
    
    [self.userImage setImage:[UIImage imageNamed:@"InstagramLoading.png"]];
    [self.imageView.superview addSubview:self.userImage];
    
    [SBInstagramModel downloadImageWithUrl:self.entity.profilePicture andBlock:^(UIImage *image2, NSError *error) {
        if (image2 && !error) {
            [self.userImage setImage:image2];
        }
    }];
    
}


#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}
@end
