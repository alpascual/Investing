/**
 * Disclaimer: IMPORTANT:  This Nulana software is supplied to you by Nulana
 * LTD ("Nulana") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this Nulana software constitutes acceptance of these terms.  If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this Nulana software.
 *
 * In consideration of your agreement to abide by the following terms, and
 * subject to these terms, Nulana grants you a personal, non-exclusive
 * license, under Nulana's copyrights in this original Nulana software (the
 * "Nulana Software"), to use, reproduce, modify and redistribute the Nulana
 * Software, with or without modifications, in source and/or binary forms;
 * provided that if you redistribute the Nulana Software in its entirety and
 * without modifications, you must retain this notice and the following
 * text and disclaimers in all such redistributions of the Nulana Software.
 * Except as expressly stated in this notice, no other rights or licenses, 
 * express or implied, are granted by Nulana herein, including but not limited 
 * to any patent rights that may be infringed by your derivative works or by other
 * works in which the Nulana Software may be incorporated.
 *
 * The Nulana Software is provided by Nulana on an "AS IS" basis.  NULANA
 * MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 * THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE, REGARDING THE NULANA SOFTWARE OR ITS USE AND
 * OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 *
 * IN NO EVENT SHALL NULANA BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 * MODIFICATION AND/OR DISTRIBUTION OF THE NULANA SOFTWARE, HOWEVER CAUSED
 * AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 * STRICT LIABILITY OR OTHERWISE, EVEN IF NULANA HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Copyright (C) 2014 Nulana LTD. All Rights Reserved.
 */
 

#import "NChart3DDelegate.h"
#import "NChart3DMainViewController.h"
#import "NChart3DVSplitViewController.h"
#import "NChart3DNavigationController.h"
#import "NChart3DTabBarController.h"


@implementation NChart3DDemoDelegate
{
    UIWindow *m_window;
}

@synthesize window = m_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    m_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    m_window.userInteractionEnabled = YES;
    m_window.multipleTouchEnabled = YES;
    [m_window makeKeyAndVisible];
    
    if (isIPhone())
    {
        NChart3DMainViewController *chartCtrl = [NChart3DMainViewController new];
        
        NChart3DNavigationController *chartNavCtrl = [[NChart3DNavigationController alloc]
                                                       initWithMainViewController:chartCtrl
                                                       settingsType:NChart3DSettingsChartSettings];
        chartNavCtrl.tabBarItem.title = NSLocalizedString(@"Charts", nil);
        chartNavCtrl.tabBarItem.image = [UIImage imageNamed:@"buttonChart.png"];
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
        
        m_window.rootViewController = tabCtrl;
    }
    else
    {
        NChart3DMainViewController *mainCtrl = [NChart3DMainViewController new];
        UINavigationController *mainNavCtrl = [[UINavigationController alloc]
                                                initWithRootViewController:mainCtrl];
        mainNavCtrl.navigationBar.backgroundColor = [UIColor whiteColor];
        mainNavCtrl.navigationBar.translucent = NO;
        
        NChart3DSettingsViewController *settingsCtrl = [[NChart3DSettingsViewController alloc]
                                                         initWithSettingsID:NChart3DSettingsChartSettings];
        settingsCtrl.settingsDelegate = mainCtrl;
        settingsCtrl.settingTypes = @[[NSNumber numberWithInt:NChart3DSettingsChartSettings],
                                      [NSNumber numberWithInt:NChart3DSettingsEffectSettings],
                                      [NSNumber numberWithInt:NChart3DSettingsStreamingSettings],
                                      [NSNumber numberWithInt:NChart3DSettingsLayout]];
        
        UINavigationController *settingsNavCtrl = [[UINavigationController alloc]
                                                    initWithRootViewController:settingsCtrl];
        
        settingsNavCtrl.navigationBar.backgroundColor = [UIColor whiteColor];
        settingsNavCtrl.navigationBar.translucent = NO;
        
        NChart3DVSplitViewController *vSplitCtrl = [[NChart3DVSplitViewController alloc] initWithLeftPanel:settingsNavCtrl
                                                                                              andRightPanel:mainNavCtrl];
        
        mainCtrl.delegate = vSplitCtrl;
        
        m_window.rootViewController = vSplitCtrl;
    }
    
    return YES;
}


@end
