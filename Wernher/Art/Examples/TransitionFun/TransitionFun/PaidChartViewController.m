//
//  PaidChartViewController.m
//  Wernher
//
//  Created by Albert Pascual on 5/21/14.
//
//

#import "PaidChartViewController.h"

@interface PaidChartViewController ()

@end

@implementation PaidChartViewController

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
    
    NChart3DMainViewController *chartCtrl = [NChart3DMainViewController new];
    
    NChart3DNavigationController *chartNavCtrl = [[NChart3DNavigationController alloc]
                                                  initWithMainViewController:chartCtrl
                                                  settingsType:NChart3DSettingsChartSettings];
    chartNavCtrl.tabBarItem.title = NSLocalizedString(@"Charts", nil);
    //chartNavCtrl.tabBarItem.image = [UIImage imageNamed:@"buttonChart.png"];
    if ([chartNavCtrl.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        chartNavCtrl.navigationBar.barTintColor = [UIColor whiteColor];
    if ([chartNavCtrl.navigationBar respondsToSelector:@selector(setTranslucent:)])
        chartNavCtrl.navigationBar.translucent = NO;
    
    NChart3DNavigationController *effectsNavCtrl = [[NChart3DNavigationController alloc]
                                                    initWithMainViewController:chartCtrl
                                                    settingsType:NChart3DSettingsEffectSettings];
    effectsNavCtrl.tabBarItem.title = NSLocalizedString(@"Effects", nil);
    effectsNavCtrl.tabBarItem.image = [UIImage imageNamed:@"buttonEffects.png"];
    if ([effectsNavCtrl.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        effectsNavCtrl.navigationBar.barTintColor = [UIColor whiteColor];
    if ([effectsNavCtrl.navigationBar respondsToSelector:@selector(setTranslucent:)])
        effectsNavCtrl.navigationBar.translucent = NO;
    
    NChart3DNavigationController *streamingNavCtrl = [[NChart3DNavigationController alloc]
                                                      initWithMainViewController:chartCtrl
                                                      settingsType:NChart3DSettingsStreamingSettings];
    streamingNavCtrl.tabBarItem.title = NSLocalizedString(@"Streaming", nil);
    streamingNavCtrl.tabBarItem.image = [UIImage imageNamed:@"buttonMic.png"];
    if ([streamingNavCtrl.navigationBar respondsToSelector:@selector(setBarTintColor:)])
        streamingNavCtrl.navigationBar.barTintColor = [UIColor whiteColor];
    if ([streamingNavCtrl.navigationBar respondsToSelector:@selector(setTranslucent:)])
        streamingNavCtrl.navigationBar.translucent = NO;
    
    NChart3DSettingsViewController *layoutCtrl = [[NChart3DSettingsViewController alloc]
                                                  initWithSettingsID:NChart3DSettingsLayout];
    layoutCtrl.settingsDelegate = chartCtrl;
    UINavigationController *layoutNavCtrl = [[UINavigationController alloc]
                                             initWithRootViewController:layoutCtrl];
    layoutNavCtrl.tabBarItem.title = NSLocalizedString(@"Layout", nil);
    layoutNavCtrl.tabBarItem.image = [UIImage imageNamed:@"buttonLayout.png"];
    
    NChart3DTabBarController *tabCtrl = [[NChart3DTabBarController alloc]
                                         initWithRootViewController:chartNavCtrl];
    if ([tabCtrl.tabBar respondsToSelector:@selector(setBarTintColor:)])
        tabCtrl.tabBar.barTintColor = [UIColor whiteColor];
    tabCtrl.viewControllers = @[chartNavCtrl, effectsNavCtrl, streamingNavCtrl, layoutNavCtrl];
    if ([tabCtrl.tabBar respondsToSelector:@selector(setTranslucent:)])
        tabCtrl.tabBar.translucent = NO;

    
    
    [self.view addSubview:chartNavCtrl.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
