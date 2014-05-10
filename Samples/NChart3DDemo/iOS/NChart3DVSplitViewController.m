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
 

#import "NChart3DVSplitViewController.h"


@interface NChart3DVSplitView : UIView

- (id)initWithLeftView:(UIView *)leftView andRightView:(UIView *)rightView;

@property (nonatomic, assign) float leftWidth;
@property (nonatomic, assign) BOOL leftViewShown;

@end

@implementation NChart3DVSplitView
{
    UIView *m_leftView;
    UIView *m_rightView;
    BOOL m_leftViewShown;
    NSTimeInterval m_animDuration;
}

@synthesize leftViewShown = m_leftViewShown;

- (id)initWithLeftView:(UIView *)leftView andRightView:(UIView *)rightView
{
    self = [super init];
    if (self)
    {
        self.leftWidth = 320.0f;
        m_leftView = leftView;
        m_rightView = rightView;
        [self addSubview:m_leftView];
        [self addSubview:m_rightView];
        m_leftViewShown = YES;
        
        /*UISwipeGestureRecognizer *leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(leftSwipe:)] autorelease];
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipeRecognizer];
        UISwipeGestureRecognizer *rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                           initWithTarget:self action:@selector(rightSwipe:)] autorelease];
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipeRecognizer];*/
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect leftRect, rightRect;
    
    if (m_leftViewShown)
    {
        leftRect = rightRect = self.bounds;
        leftRect.size.width = self.leftWidth;
        rightRect.origin.x = self.leftWidth + 1.0f;
        rightRect.size.width -= self.leftWidth + 1.0f;
    }
    else
    {
        leftRect = m_leftView.frame;
        leftRect.origin.x -= leftRect.size.width;
        rightRect = self.bounds;
    }
    
    if (m_animDuration > 0.0f)
    {
        if (m_rightView.frame.size.width < rightRect.size.width)
        {
            [UIView animateWithDuration:m_animDuration
                             animations:^{ m_leftView.frame = leftRect; m_rightView.frame = rightRect; }];
        }
        else
        {
            CGRect tmpRightRect = m_rightView.frame;
            tmpRightRect.origin.x = rightRect.origin.x;
            [UIView animateWithDuration:m_animDuration
                             animations:^{ m_leftView.frame = leftRect; m_rightView.frame = tmpRightRect; }
                             completion:^(BOOL finished){ m_rightView.frame = rightRect; }];
        }
        m_animDuration = 0.0f;
    }
    else
    {
        m_leftView.frame = leftRect;
        m_rightView.frame = rightRect;
    }
}

- (void)setLeftViewShown:(BOOL)leftViewShown
{
    m_leftViewShown = leftViewShown;
    m_animDuration = 0.25f;
    [self setNeedsLayout];
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (self.leftViewShown && [recognizer locationInView:self].x < self.leftWidth)
        self.leftViewShown = NO;
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (!(self.leftViewShown) && [recognizer locationInView:self].x < self.leftWidth)
        self.leftViewShown = YES;
}

@end

@implementation NChart3DVSplitViewController
{
    UIViewController *__weak m_leftPanel;
    UIViewController *__weak m_rightPanel;
    NChart3DVSplitView *m_view;
}

@synthesize leftPanel = m_leftPanel;
@synthesize rightPanel = m_rightPanel;

- (id)initWithLeftPanel:(UIViewController *)leftPanel andRightPanel:(UIViewController *)rightPanel
{
    self = [super init];
    if (self)
    {
        m_leftPanel = leftPanel;
        m_rightPanel = rightPanel;
    }
    return self;
}


- (void)loadView
{
    m_view = [[NChart3DVSplitView alloc] initWithLeftView:m_leftPanel.view andRightView:m_rightPanel.view];
    self.view = m_view;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [UIView setAnimationsEnabled:YES];
}

- (BOOL)isUILocked
{
    return !(self.leftPanel.view.userInteractionEnabled);
}

- (void)setIsUILocked:(BOOL)isUILocked
{
    self.leftPanel.view.userInteractionEnabled = !isUILocked;
}

- (BOOL)isSettingsPanelShown
{
    return m_view.leftViewShown;
}

- (void)setIsSettingsPanelShown:(BOOL)isSettingsPanelShown
{
    m_view.leftViewShown = isSettingsPanelShown;
}

- (UINavigationController *)navigator
{
    return nil;
}

@end
