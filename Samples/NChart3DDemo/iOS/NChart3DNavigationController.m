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
 

#import "NChart3DNavigationController.h"


@interface NChart3DTabView : UIView

@end

@implementation NChart3DTabView

- (void)layoutSubviews
{
    for (UIView *subView in self.subviews)
        subView.frame = self.bounds;
}

@end

@interface NChart3DTabViewController : UIViewController

- (id)initWithMainViewController:(UIViewController *)mainCtrl;

@end

@implementation NChart3DTabViewController
{
    NChart3DMainViewController *m_mainCtrl;
    UIActivityIndicatorView *m_spinner;
}

- (id)initWithMainViewController:(NChart3DMainViewController *)mainCtrl
{
    self = [super init];
    if (self)
    {
        m_mainCtrl = mainCtrl;
        
        // This is for iPhone only.
        UIBarButtonItem *pinItem, *animItem, *resetItem;
        
        self.title = NSLocalizedString(@"NChart3D", nil);
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            pinItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidepanel.png"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:m_mainCtrl
                                                       action:@selector(showSettings:)];
            animItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play-animation.png"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:m_mainCtrl
                                                        action:@selector(playAnim:)];
            resetItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reset.png"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:m_mainCtrl
                                                         action:@selector(resetTransformations:)];
            
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        else
        {
            pinItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil)
                                                        style:UIBarButtonItemStyleBordered
                                                       target:m_mainCtrl
                                                       action:@selector(showSettings:)];
            animItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Animate", nil)
                                                         style:UIBarButtonItemStyleBordered
                                                        target:m_mainCtrl
                                                        action:@selector(playAnim:)];
            resetItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", nil)
                                                          style:UIBarButtonItemStyleBordered
                                                         target:m_mainCtrl
                                                         action:@selector(resetTransformations:)];
        }
        
        [self.navigationItem setLeftBarButtonItems:@[resetItem, animItem]];
        [self.navigationItem setRightBarButtonItems:@[pinItem]];
    }
    return self;
}

- (void)dealloc
{
    [m_spinner stopAnimating];
    
}

- (void)loadView
{
    self.view = [NChart3DTabView new];
    m_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_spinner.backgroundColor = [UIColor grayColor];
    [self.view addSubview:m_spinner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [m_spinner startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (m_mainCtrl.delegate != (NChart3DNavigationController *)(self.navigationController))
    {
        m_mainCtrl.delegate = (NChart3DNavigationController *)(self.navigationController);
        m_mainCtrl.delegate.isUILocked = YES;
        switch (((NChart3DNavigationController *)(self.navigationController)).settingsType)
        {
            case NChart3DSettingsChartSettings:
                [m_mainCtrl settingsSetValue:[NSNumber numberWithInt:NChart3DTypesColumn]
                                     forProp:NChart3DTypeSeriesType];
                break;
                
            case NChart3DSettingsEffectSettings:
                [m_mainCtrl settingsSetValue:[NSNumber numberWithInt:NChart3DTypesPieRotation]
                                     forProp:NChart3DTypeSeriesType];
                break;
                
            case NChart3DSettingsStreamingSettings:
                [m_mainCtrl settingsSetValue:[NSNumber numberWithInt:NChart3DTypesStreamingColumn]
                                     forProp:NChart3DTypeSeriesType];
                break;
                
            default:
                break;
        }
        [m_mainCtrl.view removeFromSuperview];
        [self.view addSubview:m_mainCtrl.view];
        m_mainCtrl.delegate.isUILocked = NO;
    }
    [m_spinner stopAnimating];
}

@end

@implementation NChart3DNavigationController
{
    NChart3DSettings m_settingsType;
}

@synthesize settingsType = m_settingsType;

- (id)initWithMainViewController:(NChart3DMainViewController *)mainCtrl settingsType:(NChart3DSettings)type
{
    self = [super initWithRootViewController:[[NChart3DTabViewController alloc] initWithMainViewController:mainCtrl]];
    if (self)
    {
        m_settingsType = type;
    }
    return self;
}

- (BOOL)isUILocked
{
    return !(self.tabBarController.tabBar.userInteractionEnabled);
}

- (void)setIsUILocked:(BOOL)isUILocked
{
    self.tabBarController.tabBar.userInteractionEnabled = !isUILocked;
}

- (BOOL)isSettingsPanelShown
{
    return NO;
}

- (void)setIsSettingsPanelShown:(BOOL)isSettingsPanelShown
{
    // nop
}

- (UINavigationController *)navigator
{
    return self;
}

@end
