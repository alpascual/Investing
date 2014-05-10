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
 

#import "NChart3DMainViewController.h"


@implementation NChart3DMainViewController
{
    NChart3DView *m_view;
    BOOL m_prevZAxisShouldBeShorter;
    int m_prevSeriesCount;
    NSArray *m_arrayOfYears;
    NSArray *m_arrayOfSeriesNames;
    NSArray *m_arrayOfXSteps;
    BOOL m_isUILocked;
    NChart3DAudioCapturer *m_audioCapturer;
    NChart3DAxesDataSource *m_axesDataSource;
    NChart3DSeriesDataSource *m_seriesDataSource;
    NChart3DChartDelegate *m_delegate;
}

@synthesize arrayOfYears = m_arrayOfYears;
@synthesize arrayOfSeriesNames = m_arrayOfSeriesNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // This is for iPad only. For iPhone NChart3DNavigationController is used.
        UIBarButtonItem *pinItem, *animItem, *resetItem, *aboutItem;
        
        self.title = NSLocalizedString(@"NChart3D", nil);
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            pinItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidepanel.png"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(pinSettings:)];
            animItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play-animation.png"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(playAnim:)];
            resetItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reset.png"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(resetTransformations:)];
            aboutItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"about.png"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(about:)];
            
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        }
        else
        {
            pinItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings", nil)
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(pinSettings:)];
            animItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Animate", nil)
                                                        style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(playAnim:)];
            resetItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", nil)
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(resetTransformations:)];
            aboutItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", nil)
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(about:)];
        }
        
        [self.navigationItem setLeftBarButtonItems:@[pinItem]];
        [self.navigationItem setRightBarButtonItems:@[resetItem, animItem]];
    }
    return self;
}


- (void)loadView
{
    m_view = [[NChart3DView alloc] initWithFrame:CGRectZero];
    
    // Paste your license key here.
    m_view.chart.licenseKey = @"g1cVXBngoHRaVLr9syklcughDTqr/CJtaBTlEe7dArHYxZHlrF9J8vFb/zrE1+90xI93KFjMKJ+e/A8mxx1AFb/tEZAV66M3M2l2lsfYVXiJXuzar0ewDo8yoRLFfT7tNn8N7kW/WjBODSPL7UULnRVe04PE8VLcMQdociifAsEcfh6UdUoLMzR3ktd95V2RCAIMwyh6bGZhiy8LXwfY7GVFNohMpYErO/ayDWEd0HIfYijXWikJUydYeijL1c4DAKLMiguJtYh0Kg7+90y+VtR2EuCMZPg6tmNVS8FUCwTblLzMM6h17F1AYQHGPgKjQqT/aL3HKTHrCwJuqKhzdEthgm9jT+zfj6zFFfJaQq3XNtw8x5IoFcPR5DVb/DdX26DhqTmnNqeloinFInsPhaUJHywycTg+3034uS4OLmLdzyzvQl9rlEvp7NRs0UFuBg26AmqUaVeJHOXSK8zyw8rbwIe5HqqKkHIeS5WPv99baaNb5X9PMxEvm6hjUiD5QcqisfgI4zbwyxBwyCuoUEPSX3niJ3mQeUMKUkBbjk2eX1w+N4wxczVEuqsH5YGMTXLWt5pQV+cMl7s+daeuCSYJ/VAYMQrwOT7TfjWmA7vYhviZqkSLbxAyEt/Vd1162rbJPAQLiuSAr1VMgCWZxU8f9kjEFXb/1vssFaob2+c=";
    
    self.view = m_view;
    
    // Set data sources
    m_axesDataSource = [[NChart3DAxesDataSource alloc] initWithMainViewController:self];
    m_view.chart.cartesianSystem.xAxis.dataSource = m_axesDataSource;
    m_view.chart.cartesianSystem.yAxis.dataSource = m_axesDataSource;
    m_view.chart.cartesianSystem.zAxis.dataSource = m_axesDataSource;
    m_view.chart.sizeAxis.dataSource = m_axesDataSource;
    m_view.chart.timeAxis.dataSource = m_axesDataSource;
    
    m_delegate = [[NChart3DChartDelegate alloc] initWithMainViewController:self];
    
    [self setupChart];
    [self applyColorScheme];
    
    m_seriesDataSource = [[NChart3DSeriesDataSource alloc] initWithMainViewController:self];
    
    // Default settings
    self.colorScheme = NChart3DColorSchemeLight;
    self.seriesType = NChart3DTypesScatter; //NChart3DTypesColumn;
    self.seriesCount = 4;
    self.yearsCount = 5;
    self.spectrum2DCount = 100;
    self.showBorder = NO;
    self.showLabels = NO;
    self.showMarkers = NO;
    self.drawIn3D = YES;
    self.sliceCount = 4;
    self.smoothColumn = NO;
    self.showLegend = YES;
    self.spectrum3DCount = 40;
    
    [self createSeries];
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"NChart3DUpdateSettings" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"StartupInfoShown"])
    {
        [self about:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"StartupInfoShown"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSArray *)arrayOfYears
{
    if (m_arrayOfYears.count != self.yearsCount)
    {
        NSMutableArray *result = [NSMutableArray array];
        for (int i = 2013 - self.yearsCount + 1; i <= 2013; ++i)
            [result addObject:[NSString stringWithFormat:@"%d", i]];
        self.arrayOfYears = result;
    }
    return m_arrayOfYears;
}

- (NSArray *)arrayOfSeriesNames
{
    if (m_arrayOfSeriesNames.count != self.seriesCount)
    {
        NSMutableArray *result = [NSMutableArray array];
        for (int i = 0; i < self.seriesCount; ++i)
            [result addObject:[NSString stringWithFormat:NSLocalizedString(@"Series %d", nil), i + 1]];
        self.arrayOfSeriesNames = result;
    }
    return m_arrayOfSeriesNames;
}

- (int)spectrumStep
{
    return (int)roundf((float)(m_audioCapturer.sampleRate) / (float)(m_audioCapturer.spectrumSize));
}

#pragma mark - Effects

- (void)lockUI:(BOOL)lock
{
    m_isUILocked = lock;
    self.delegate.isUILocked = m_isUILocked;
}

- (void)pieAnimationWithStep:(NSNumber *)step
{
    switch ([step intValue])
    {
        case 0:
        {
            [self lockUI:YES];
            m_view.chart.userInteractionMode = m_view.chart.userInteractionMode ^ NChartUserInteractionHorizontalRotate;
            NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
            settings.holeRatio = 0.3f;
            [m_view.chart addSeriesSettings:settings];
            
            [m_view.chart rebuildSeries];
            [m_view.chart stopTransition];
            [m_view.chart playTransition:TRANSITION_TIME reverse:NO];
            
            [self performSelector:@selector(pieAnimationWithStep:) withObject:@1 afterDelay:TRANSITION_TIME];
        }
            break;

        case 1:
        {
            float duration = self.yearsCount / 3.0f;
            float angle = m_view.chart.horizontalRotationAngle + 0.698f * self.yearsCount * 2.0f - floorf(self.yearsCount / 4.0f);
            [m_view.chart rotateHorizontallyToAngle:angle
                                           duration:duration
                                              delay:0.0f
                                       interpolator:[NChartBezierInterpolator bezierInterpolatorWithControlPoint:angle]];
            for (NChartSeries *series in m_view.chart.series)
            {
                for (NChartPoint *p in series.points)
                {
                    p.highlightShift = 0.3f;
                    [p highlightWithMask:NChartHighlightTypeShift duration:TRANSITION_TIME delay:TRANSITION_TIME * p.currentState.circle / 1.5f];
                    [p highlightWithMask:NChartHighlightTypeNone duration:TRANSITION_TIME delay:TRANSITION_TIME / 2.0f];
                }
            }
            [self performSelector:@selector(pieAnimationWithStep:) withObject:@2 afterDelay:TRANSITION_TIME * self.yearsCount / 1.5f + TRANSITION_TIME * 2.0f];
        }
            break;
            
        case 2:
        {
            NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
            settings.holeRatio = 0.0f;
            [m_view.chart addSeriesSettings:settings];
            [self rebuildSeries];
            [self performSelector:@selector(pieAnimationWithStep:) withObject:@3 afterDelay:TRANSITION_TIME];
        }
            break;
            
        case 3:
            [self lockUI:NO];
            m_view.chart.userInteractionMode = m_view.chart.userInteractionMode | NChartUserInteractionHorizontalRotate;
            break;
    }
}

#pragma mark - Toolbar actions

- (void)showSettings:(id)dummy
{
    NChart3DSettings type;
    switch (self.seriesType)
    {
        case NChart3DTypesColumn:
        case NChart3DTypesBar:
        case NChart3DTypesArea:
        case NChart3DTypesLine:
        case NChart3DTypesStep:
        case NChart3DTypesRibbon:
        case NChart3DTypesPie:
        case NChart3DTypesDoughnut:
        case NChart3DTypesBubble:
        case NChart3DTypesScatter:
        case NChart3DTypesSurface:
        case NChart3DTypesCandlestick:
        case NChart3DTypesOHLC:
        case NChart3DTypesBand:
        case NChart3DTypesSequence:
            type = NChart3DSettingsChartSettings;
            break;
            
        case NChart3DTypesPieRotation:
        case NChart3DTypesMultichart:
            type = NChart3DSettingsEffectSettings;
            break;
            
        case NChart3DTypesStreamingColumn:
        case NChart3DTypesStreamingArea:
        case NChart3DTypesStreamingLine:
        case NChart3DTypesStreamingStep:
        case NChart3DTypesStreamingSurface:
            type = NChart3DSettingsStreamingSettings;
            break;
    }
    NChart3DSettingsViewController *ctrl = [[NChart3DSettingsViewController alloc] initWithSettingsID:type];
    ctrl.settingsDelegate = self;
    [self.delegate.navigator pushViewController:ctrl animated:YES];
}

- (void)pinSettings:(id)dummy
{
    if (m_isUILocked)
        return;
    
    self.delegate.isSettingsPanelShown = !(self.delegate.isSettingsPanelShown);
}

- (void)playAnim:(id)dummy
{
    if (m_isUILocked)
        return;
    
    switch (self.seriesType)
    {
        case NChart3DTypesPieRotation:
            [self pieAnimationWithStep:@0];
            break;
            
        case NChart3DTypesStreamingArea:
        case NChart3DTypesStreamingColumn:
        case NChart3DTypesStreamingLine:
        case NChart3DTypesStreamingStep:
        case NChart3DTypesStreamingSurface:
            break;
            
        default:
            if (![m_view.chart isTransitionPlaying])
            {
                [m_delegate chartDelegatePointOfChart:nil selected:nil];
                
                [m_view.chart stopTransition];
                [m_view.chart playTransition:TRANSITION_TIME reverse:YES];
                [m_view.chart playTransition:TRANSITION_TIME reverse:NO];
            }
            break;
    }
}

- (void)resetTransformations:(id)dummy
{
    if (m_isUILocked)
        return;
    
    [m_view.chart resetTransformations:TRANSITION_TIME];
}

- (void)about:(id)dummy
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"About", nil)
                                                    message:NSLocalizedString(@"The application demonstrates the features of NChart3D charting library. More information and documentation can be found at www.nchart3d.com.", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:NSLocalizedString(@"nchart3d.com", nil), nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://nchart3d.com"]];
    }
}

#pragma mark - NChart3DSettingsDelegate

- (id)settingsValueForProp:(NSInteger)prop
{
    switch (prop)
    {
        case NChart3DTypeSeriesType:
            return [NSNumber numberWithInt:self.seriesType];
            
        case NChart3DDataAxesType:
            return [NSNumber numberWithInt:m_view.chart.cartesianSystem.valueAxesType];
            
        case NChart3DDataSeriesCount:
            return [NSNumber numberWithInt:self.seriesCount];
            
        case NChart3DDataYearsCount:
            return [NSNumber numberWithInt:self.yearsCount];
            
        case NChart3DDataSpectrum2DCount:
            return [NSNumber numberWithInt:self.spectrum2DCount];
            
        case NChart3DLayoutShowBorder:
            return [NSNumber numberWithBool:self.showBorder];
            
        case NChart3DLayoutShowLabels:
            return [NSNumber numberWithBool:self.showLabels];
            
        case NChart3DLayoutShowMarkers:
            return [NSNumber numberWithBool:self.showMarkers];
            
        case NChart3DLayoutLegend:
            return [NSNumber numberWithBool:self.showLegend];
            
        case NChart3DLayoutCaption:
            return [NSNumber numberWithBool:m_view.chart.caption.visible];
            
        case NChart3DLayoutXAxis:
            return [NSNumber numberWithBool:m_view.chart.cartesianSystem.xAxis.visible];
            
        case NChart3DLayoutYAxis:
            return [NSNumber numberWithBool:m_view.chart.cartesianSystem.yAxis.visible];
            
        case NChart3DLayoutZAxis:
            return [NSNumber numberWithBool:m_view.chart.cartesianSystem.zAxis.visible];
            
        case NChart3DLayoutColorScheme:
            return [NSNumber numberWithInt:self.colorScheme];
            
        case NChart3DDataFunctionType:
            return [NSNumber numberWithInt:self.functionType];
            
        case NChart3DDataDimension:
            return [NSNumber numberWithBool:self.drawIn3D];
            
        case NChart3DLayoutSlice:
            return [NSNumber numberWithInt:self.sliceCount];
            
        case NChart3DLayoutSmooth:
            return [NSNumber numberWithBool:self.smoothColumn];
            
        case NChart3DDataSpectrum3DCount:
            return [NSNumber numberWithInt:self.spectrum3DCount];
            
        default:
            return nil;
    }
}

- (void)settingsSetValue:(id)value forProp:(NSInteger)prop
{
    switch (prop)
    {
        case NChart3DTypeSeriesType:
            [m_audioCapturer stopCaptureSession];
            self.seriesType = ((NSNumber *)value).intValue;
            if (!isIPhone())
                [NSNotificationCenter.defaultCenter postNotificationName:@"NChart3DUpdateSettings" object:nil];
            [self createSeries];
            break;
            
        case NChart3DDataAxesType:
            m_view.chart.cartesianSystem.valueAxesType = (NChartValueAxesType)(((NSNumber *)value).intValue);
            [m_view.chart updateData];
            [m_delegate resetPopup];
            [m_view.chart stopTransition];
            [m_view.chart playTransition:TRANSITION_TIME reverse:NO];
            [NSNotificationCenter.defaultCenter postNotificationName:@"NChart3DUpdateSettings" object:nil];
            [self resetTransformationsIfNeeded];
            break;
            
        case NChart3DDataSeriesCount:
            self.seriesCount = ((NSNumber *)value).intValue;
            [self createSeries];
            break;
            
        case NChart3DDataYearsCount:
            self.yearsCount = ((NSNumber *)value).intValue;
            [self createSeries];
            break;
            
        case NChart3DLayoutShowBorder:
            self.showBorder = ((NSNumber *)value).boolValue;
            [m_delegate resetPopup];
            [m_seriesDataSource applyColorSchemeToSeries];
            if (m_view.chart.drawIn3D && (self.seriesType == NChart3DTypesBubble || self.seriesType == NChart3DTypesScatter))
                [self rebuildSeries];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            break;
            
        case NChart3DLayoutShowLabels:
            self.showLabels = ((NSNumber *)value).boolValue;
            [m_delegate resetPopup];
            [m_seriesDataSource applyColorSchemeToSeries];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            break;
            
        case NChart3DLayoutShowMarkers:
            self.showMarkers = ((NSNumber *)value).boolValue;
            [m_delegate resetPopup];
            [m_seriesDataSource applyColorSchemeToSeries];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            break;
            
        case NChart3DLayoutLegend:
            m_view.chart.legend.visible = self.showLegend = ((NSNumber *)value).boolValue;
            break;
            
        case NChart3DLayoutCaption:
            m_view.chart.caption.visible = ((NSNumber *)value).boolValue;
            break;
            
        case NChart3DLayoutXAxis:
            m_view.chart.cartesianSystem.xAxis.visible = ((NSNumber *)value).boolValue;
            break;
            
        case NChart3DLayoutYAxis:
            m_view.chart.cartesianSystem.yAxis.visible = ((NSNumber *)value).boolValue;
            break;
            
        case NChart3DLayoutZAxis:
            m_view.chart.cartesianSystem.zAxis.visible = ((NSNumber *)value).boolValue;
            break;
            
        case NChart3DLayoutColorScheme:
            self.colorScheme = (NChart3DColorScheme)(((NSNumber *)value).intValue);
            [m_audioCapturer stopCaptureSession];
            [m_delegate resetPopup];
            [self applyColorScheme];
            [m_seriesDataSource applyColorSchemeToSeries];
            [m_view.chart relayout];
            [m_audioCapturer startCaptureSession];
            [NSNotificationCenter.defaultCenter postNotificationName:@"NChart3DUpdateSettings" object:nil];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            break;
            
        case NChart3DDataFunctionType:
            self.functionType = (NChart3DFunctionType)(((NSNumber *)value).intValue);
            [self rebuildSeries];
            [m_view.chart relayout];
            break;
            
        case NChart3DDataDimension:
            [m_audioCapturer stopCaptureSession];
            self.drawIn3D = (((NSNumber *)value).intValue) == NChart3DDimensions3D;
            [self createSeries];
            [NSNotificationCenter.defaultCenter postNotificationName:@"NChart3DUpdateSettings" object:nil];
            break;
            
        case NChart3DLayoutSlice:
            self.sliceCount = ((NSNumber *)value).intValue;
            [self createSeries];
            break;
            
        case NChart3DLayoutSmooth:
            self.smoothColumn = ((NSNumber *)value).boolValue;
            [self createSeries];
            break;
            
        case NChart3DDataSpectrum2DCount:
            [m_audioCapturer stopCaptureSession];
            self.spectrum2DCount = ((NSNumber *)value).intValue;
            [self createSeries];
            break;
            
        case NChart3DDataSpectrum3DCount:
            [m_audioCapturer stopCaptureSession];
            self.spectrum3DCount = ((NSNumber *)value).intValue;
            [self createSeries];
            break;
            
        default:
            break;
    }
}

#pragma mark - Apply settings to chart

- (void)setImagesForTimeAxisSlider:(NSString *)sliderName
                           handler:(NSString *)handlerName
                        playNormal:(NSString *)playNormalName
                        playPushed:(NSString *)playPushedName
                       pauseNormal:(NSString *)pauseNormalName
                       pausePushed:(NSString *)pausePushedName
{
    UIImage *slider = [UIImage imageNamed:sliderName];
    UIImage *handler = [UIImage imageNamed:handlerName];
    UIEdgeInsets capInsets;
    capInsets.left = 0.42f * slider.size.width;
    capInsets.right = 0.58f * slider.size.width;
    capInsets.bottom = capInsets.top = 0.0f;
    [m_view.chart.timeAxis setSliderImage:slider capInsets:capInsets];
    [m_view.chart.timeAxis setHandlerImage:handler];
    [m_view.chart.timeAxis setPlayButtonStateImagesNormal:[UIImage imageNamed:playNormalName]
                                                andPushed:[UIImage imageNamed:playPushedName]];
    [m_view.chart.timeAxis setPauseButtonStateImagesNormal:[UIImage imageNamed:pauseNormalName]
                                                 andPushed:[UIImage imageNamed:pausePushedName]];
    m_view.chart.timeAxis.tickSize = CGSizeMake(1.0f, slider.size.height * 4.0f);
    m_view.chart.timeAxis.tickOffset = round((handler.size.height - slider.size.height) / 2.0f) - 3.0f;
}

- (void)setupChart
{
    // Time axis
    m_view.chart.timeAxis.tickShape = NChartTimeAxisTickShapeLine;
    m_view.chart.timeAxis.tickTitlesFont = BoldFontWithSize(11.0f);
    m_view.chart.timeAxis.tickTitlesLayout = NChartTimeAxisShowFirstLastLabelsOnly;
    m_view.chart.timeAxis.tickTitlesPosition = NChartTimeAxisLabelsBeneath;
    m_view.chart.timeAxis.margin = NChartMarginMake(20.0f, 20.0f, 10.0f, 0.0f);
    m_view.chart.timeAxis.autohideTooltip = NO;
    
    // Time axis tooltip
    m_view.chart.timeAxis.tooltip = [NChartTimeAxisTooltip new];
    m_view.chart.timeAxis.tooltip.textColor = ColorWithRGB(145, 143, 141);
    m_view.chart.timeAxis.tooltip.font = FontWithSize(11.0f);
    
    // Legend
    m_view.chart.legend.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:1.0f
                                                                                                     green:1.0f
                                                                                                      blue:1.0f
                                                                                                     alpha:0.8f]];
    m_view.chart.legend.borderThickness = 0.5f;
    m_view.chart.legend.borderColor = ColorWithRGB(185, 185, 185);
    m_view.chart.legend.blockAlignment = NChartLegendBlockAlignmentBottom;
    m_view.chart.legend.contentAlignment = NChartLegendContentAlignmentJustified;
    
    // Caption
    m_view.chart.caption.margin = NChartMarginMake(0.0f, 0.0f, 0.0f, 5.0f);
    
    // Antialiasing
    m_view.chart.shouldAntialias = YES;
    
    // Delegate
    m_view.chart.delegate = m_delegate;
    
    // Enable selection point
    m_view.chart.pointSelectionEnabled = YES;
}

- (void)applyColorScheme
{
    UIColor *axesColor = nil;
    UIColor *saxesColor = nil;
    UIColor *textColor = nil;
    UIFont *font = nil;
    
    switch (self.colorScheme)
    {
        case NChart3DColorSchemeLight:
            self.brushes = @[BrushWithRGB(97, 206, 231),
                             BrushWithRGB(203, 220, 56),
                             BrushWithRGB(229, 74, 131),
                             BrushWithRGB(114, 127, 242),
                             BrushWithRGB(69, 215, 90),
                             BrushWithRGB(233, 114, 74),
                             BrushWithRGB(192, 102, 242),
                             BrushWithRGB(235, 177, 24),
                             BrushWithRGB(153, 113, 242)];
            self.gradientBrushes = @[GradientBrushWithRGB(93, 186, 234, 101, 226, 227),
                                     GradientBrushWithRGB(208, 201, 19, 198, 239, 92),
                                     GradientBrushWithRGB(224, 35, 120, 233, 113, 140),
                                     GradientBrushWithRGB(120, 83, 242, 107, 171, 242),
                                     GradientBrushWithRGB(65, 204, 38, 73, 226, 141),
                                     GradientBrushWithRGB(229, 93, 46, 238, 135, 102),
                                     GradientBrushWithRGB(189, 62, 242, 194, 142, 242),
                                     GradientBrushWithRGB(233, 149, 29, 237, 204, 20),
                                     GradientBrushWithRGB(154, 83, 242, 152, 142, 242)];
            self.contrastGradientBrushes = @[GradientBrushWithRGB(36, 136, 201, 122, 254, 254),
                                             GradientBrushWithRGB(163, 154, 0, 226, 255, 111),
                                             GradientBrushWithRGB(195, 2, 58, 255, 136, 166),
                                             GradientBrushWithRGB(57, 29, 199, 129, 199, 255),
                                             GradientBrushWithRGB(18, 161, 3, 89, 255, 168),
                                             GradientBrushWithRGB(199, 35, 7, 255, 161, 124),
                                             GradientBrushWithRGB(137, 16, 197, 222, 168, 255),
                                             GradientBrushWithRGB(198, 86, 0, 255, 233, 0),
                                             GradientBrushWithRGB(90, 28, 196, 179, 168, 255)];
            
            axesColor = ColorWithRGB(130, 130, 130);
            saxesColor = ColorWithRGB(180, 180, 180);
            textColor = [UIColor blackColor];
            font = FontWithSize(16.0f);
            
            m_view.chart.background = GradientBrushWithRGB(255, 255, 255, 219, 219, 224);
            m_view.chart.cartesianSystem.xyPlane.color = ColorWithRGB(238, 238, 238);
            m_view.chart.timeAxis.tooltip.textColor = ColorWithRGB(145, 143, 141);
            m_view.chart.timeAxis.tickTitlesColor = ColorWithRGB(145, 143, 141);
            m_view.chart.timeAxis.tickColor = ColorWithRGB(111, 111, 111);
            [self setImagesForTimeAxisSlider:@"slider-light.png"
                                     handler:@"handler-light.png"
                                  playNormal:@"play-light.png"
                                  playPushed:@"play-pushed-light.png"
                                 pauseNormal:@"pause-light.png"
                                 pausePushed:@"pause-pushed-light.png"];

            break;
            
        case NChart3DColorSchemeDark:
            self.brushes = @[BrushWithRGB(82, 174, 194),
                             BrushWithRGB(171, 186, 47),
                             BrushWithRGB(193, 62, 110),
                             BrushWithRGB(96, 107, 204),
                             BrushWithRGB(58, 182, 76),
                             BrushWithRGB(197, 96, 62),
                             BrushWithRGB(162, 86, 204),
                             BrushWithRGB(198, 150, 20),
                             BrushWithRGB(129, 95, 204),
                             BrushWithRGB(0, 194, 173)];
            self.gradientBrushes = @[GradientBrushWithRGB(83, 167, 210, 90, 203, 203),
                                     GradientBrushWithRGB(186, 180, 17, 178, 214, 83),
                                     GradientBrushWithRGB(201, 31, 107, 208, 101, 126),
                                     GradientBrushWithRGB(107, 74, 217, 96, 153, 217),
                                     GradientBrushWithRGB(58, 183, 34, 66, 203, 127),
                                     GradientBrushWithRGB(205, 83, 41, 214, 121, 92),
                                     GradientBrushWithRGB(169, 55, 217, 174, 128, 217),
                                     GradientBrushWithRGB(209, 134, 26, 213, 183, 18),
                                     GradientBrushWithRGB(138, 74, 217, 136, 128, 217)];
            self.contrastGradientBrushes = @[GradientBrushWithRGB(46, 115, 150, 123, 227, 227),
                                             GradientBrushWithRGB(130, 125, 0, 205, 236, 116),
                                             GradientBrushWithRGB(141, 3, 65, 230, 134, 159),
                                             GradientBrushWithRGB(65, 38, 153, 128, 184, 239),
                                             GradientBrushWithRGB(25, 128, 6, 96, 227, 160),
                                             GradientBrushWithRGB(144, 46, 11, 235, 156, 127),
                                             GradientBrushWithRGB(115, 23, 154, 203, 168, 239),
                                             GradientBrushWithRGB(149, 87, 0, 235, 210, 0),
                                             GradientBrushWithRGB(91, 38, 156, 169, 161, 239)];
            
            axesColor = ColorWithRGB(150, 150, 150);
            saxesColor = ColorWithRGB(110, 110, 110);
            textColor = [UIColor whiteColor];
            font = BoldFontWithSize(16.0f);
            
            m_view.chart.background = GradientBrushWithRGB(100, 100, 100, 44, 44, 44);
            m_view.chart.cartesianSystem.xyPlane.color = ColorWithRGB(70, 70, 70);
            m_view.chart.timeAxis.tooltip.textColor = [UIColor whiteColor];
            m_view.chart.timeAxis.tickTitlesColor = [UIColor whiteColor];
            m_view.chart.timeAxis.tickColor = ColorWithRGB(221, 221, 221);
            [self setImagesForTimeAxisSlider:@"slider-light.png"
                                     handler:@"handler-dark.png"
                                  playNormal:@"play-dark.png"
                                  playPushed:@"play-pushed-dark.png"
                                 pauseNormal:@"pause-dark.png"
                                 pausePushed:@"pause-pushed-dark.png"];

            break;
            
        case NChart3DColorSchemeSimple:
            self.brushes = @[BrushWithRGB(97, 206, 231),
                             BrushWithRGB(203, 220, 56),
                             BrushWithRGB(229, 74, 131),
                             BrushWithRGB(114, 127, 242),
                             BrushWithRGB(69, 215, 90),
                             BrushWithRGB(233, 114, 74),
                             BrushWithRGB(192, 102, 242),
                             BrushWithRGB(235, 177, 24),
                             BrushWithRGB(153, 113, 242),
                             BrushWithRGB(0, 226, 198)];
            self.gradientBrushes = @[GradientBrushWithRGB(93, 186, 234, 101, 226, 227),
                                     GradientBrushWithRGB(208, 201, 19, 198, 239, 92),
                                     GradientBrushWithRGB(224, 35, 120, 233, 113, 140),
                                     GradientBrushWithRGB(120, 83, 242, 107, 171, 242),
                                     GradientBrushWithRGB(65, 204, 38, 73, 226, 141),
                                     GradientBrushWithRGB(229, 93, 46, 238, 135, 102),
                                     GradientBrushWithRGB(189, 62, 242, 194, 142, 242),
                                     GradientBrushWithRGB(233, 149, 29, 237, 204, 20),
                                     GradientBrushWithRGB(154, 83, 242, 152, 142, 242)];
            self.contrastGradientBrushes = @[GradientBrushWithRGB(36, 136, 201, 122, 254, 254),
                                             GradientBrushWithRGB(163, 154, 0, 226, 255, 111),
                                             GradientBrushWithRGB(195, 2, 58, 255, 136, 166),
                                             GradientBrushWithRGB(57, 29, 199, 129, 199, 255),
                                             GradientBrushWithRGB(18, 161, 3, 89, 255, 168),
                                             GradientBrushWithRGB(199, 35, 7, 255, 161, 124),
                                             GradientBrushWithRGB(137, 16, 197, 222, 168, 255),
                                             GradientBrushWithRGB(198, 86, 0, 255, 233, 0),
                                             GradientBrushWithRGB(90, 28, 196, 179, 168, 255)];
            
            axesColor = ColorWithRGB(130, 130, 130);
            saxesColor = ColorWithRGB(180, 180, 180);
            textColor = [UIColor blackColor];
            font = FontWithSize(16.0f);
            
            m_view.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor whiteColor]];
            m_view.chart.cartesianSystem.xyPlane.color = ColorWithRGB(238, 238, 238);
            m_view.chart.timeAxis.tooltip.textColor = ColorWithRGB(145, 143, 141);
            m_view.chart.timeAxis.tickTitlesColor = ColorWithRGB(145, 143, 141);
            m_view.chart.timeAxis.tickColor = ColorWithRGB(111, 111, 111);
            [self setImagesForTimeAxisSlider:@"slider-light.png"
                                     handler:@"handler-light.png"
                                  playNormal:@"play-light.png"
                                  playPushed:@"play-pushed-light.png"
                                 pauseNormal:@"pause-light.png"
                                 pausePushed:@"pause-pushed-light.png"];
            
            break;
            
        case NChart3DColorSchemeTextured:
            self.brushes = @[BrushWithRGB(82, 174, 194),
                             BrushWithRGB(171, 186, 47),
                             BrushWithRGB(193, 62, 110),
                             BrushWithRGB(96, 107, 204),
                             BrushWithRGB(58, 182, 76),
                             BrushWithRGB(197, 96, 62),
                             BrushWithRGB(162, 86, 204),
                             BrushWithRGB(198, 150, 20),
                             BrushWithRGB(129, 95, 204),
                             BrushWithRGB(0, 194, 173)];
            self.gradientBrushes = @[GradientBrushWithRGB(83, 167, 210, 90, 203, 203),
                                     GradientBrushWithRGB(186, 180, 17, 178, 214, 83),
                                     GradientBrushWithRGB(201, 31, 107, 208, 101, 126),
                                     GradientBrushWithRGB(107, 74, 217, 96, 153, 217),
                                     GradientBrushWithRGB(58, 183, 34, 66, 203, 127),
                                     GradientBrushWithRGB(205, 83, 41, 214, 121, 92),
                                     GradientBrushWithRGB(169, 55, 217, 174, 128, 217),
                                     GradientBrushWithRGB(209, 134, 26, 213, 183, 18),
                                     GradientBrushWithRGB(138, 74, 217, 136, 128, 217)];
            self.contrastGradientBrushes = @[GradientBrushWithRGB(46, 115, 150, 123, 227, 227),
                                             GradientBrushWithRGB(130, 125, 0, 205, 236, 116),
                                             GradientBrushWithRGB(141, 3, 65, 230, 134, 159),
                                             GradientBrushWithRGB(65, 38, 153, 128, 184, 239),
                                             GradientBrushWithRGB(25, 128, 6, 96, 227, 160),
                                             GradientBrushWithRGB(144, 46, 11, 235, 156, 127),
                                             GradientBrushWithRGB(115, 23, 154, 203, 168, 239),
                                             GradientBrushWithRGB(149, 87, 0, 235, 210, 0),
                                             GradientBrushWithRGB(91, 38, 156, 169, 161, 239)];
            
            axesColor = ColorWithRGB(150, 150, 150);
            saxesColor = ColorWithRGB(110, 110, 110);
            textColor = [UIColor whiteColor];
            font = BoldFontWithSize(16.0f);
            
            m_view.chart.background = [NChartTextureBrush textureBrushWithImage:[UIImage imageNamed:@"background.jpg"]
                                                                backgroundColor:[UIColor blackColor]
                                                                       position:NChartTexturePositionScaleKeepMaxAspect];
            m_view.chart.cartesianSystem.xyPlane.color = ColorWithRGB(70, 70, 70);
            m_view.chart.timeAxis.tooltip.textColor = [UIColor whiteColor];
            m_view.chart.timeAxis.tickTitlesColor = [UIColor whiteColor];
            m_view.chart.timeAxis.tickColor = ColorWithRGB(221, 221, 221);
            [self setImagesForTimeAxisSlider:@"slider-light.png"
                                     handler:@"handler-dark.png"
                                  playNormal:@"play-image.png"
                                  playPushed:@"play-pushed-image.png"
                                 pauseNormal:@"pause-image.png"
                                 pausePushed:@"pause-pushed-image.png"];
            
            break;

    }
    
    m_view.chart.caption.textColor = textColor;
    m_view.chart.caption.font = font;
    
    m_view.chart.cartesianSystem.xAxis.caption.textColor = textColor;
    m_view.chart.cartesianSystem.xAxis.caption.font = font;
    m_view.chart.cartesianSystem.xAxis.textColor = textColor;
    m_view.chart.cartesianSystem.xAxis.font = font;
    m_view.chart.cartesianSystem.xAxis.color = axesColor;
    m_view.chart.cartesianSystem.xAxis.majorTicks.color = axesColor;
    m_view.chart.cartesianSystem.xAxis.minorTicks.color = axesColor;
    m_view.chart.cartesianSystem.xAlongY.color = axesColor;
    m_view.chart.cartesianSystem.xAlongZ.color = axesColor;
    
    m_view.chart.cartesianSystem.sxAxis.caption.textColor = textColor;
    m_view.chart.cartesianSystem.sxAxis.caption.font = font;
    m_view.chart.cartesianSystem.sxAxis.textColor = textColor;
    m_view.chart.cartesianSystem.sxAxis.font = font;
    m_view.chart.cartesianSystem.sxAxis.color = axesColor;
    m_view.chart.cartesianSystem.sxAxis.majorTicks.color = saxesColor;
    m_view.chart.cartesianSystem.sxAxis.minorTicks.color = saxesColor;
    m_view.chart.cartesianSystem.sxAlongY.color = saxesColor;
    m_view.chart.cartesianSystem.sxAlongZ.color = saxesColor;
    
    m_view.chart.cartesianSystem.yAxis.caption.textColor = textColor;
    m_view.chart.cartesianSystem.yAxis.caption.font = font;
    m_view.chart.cartesianSystem.yAxis.textColor = textColor;
    m_view.chart.cartesianSystem.yAxis.font = font;
    m_view.chart.cartesianSystem.yAxis.color = axesColor;
    m_view.chart.cartesianSystem.yAxis.majorTicks.color = axesColor;
    m_view.chart.cartesianSystem.yAxis.minorTicks.color = axesColor;
    m_view.chart.cartesianSystem.yAlongX.color = axesColor;
    m_view.chart.cartesianSystem.yAlongZ.color = axesColor;
    
    m_view.chart.cartesianSystem.syAxis.caption.textColor = textColor;
    m_view.chart.cartesianSystem.syAxis.caption.font = font;
    m_view.chart.cartesianSystem.syAxis.textColor = textColor;
    m_view.chart.cartesianSystem.syAxis.font = font;
    m_view.chart.cartesianSystem.syAxis.color = axesColor;
    m_view.chart.cartesianSystem.syAxis.majorTicks.color = saxesColor;
    m_view.chart.cartesianSystem.syAxis.minorTicks.color = saxesColor;
    m_view.chart.cartesianSystem.syAlongX.color = saxesColor;
    m_view.chart.cartesianSystem.syAlongZ.color = saxesColor;
    
    m_view.chart.cartesianSystem.zAxis.caption.textColor = textColor;
    m_view.chart.cartesianSystem.zAxis.caption.font = font;
    m_view.chart.cartesianSystem.zAxis.textColor = textColor;
    m_view.chart.cartesianSystem.zAxis.font = font;
    m_view.chart.cartesianSystem.zAxis.color = axesColor;
    m_view.chart.cartesianSystem.zAxis.majorTicks.color = axesColor;
    m_view.chart.cartesianSystem.zAxis.minorTicks.color = axesColor;
    m_view.chart.cartesianSystem.zAlongX.color = axesColor;
    m_view.chart.cartesianSystem.zAlongY.color = axesColor;
    
    m_view.chart.cartesianSystem.szAxis.caption.textColor = textColor;
    m_view.chart.cartesianSystem.szAxis.caption.font = font;
    m_view.chart.cartesianSystem.szAxis.textColor = textColor;
    m_view.chart.cartesianSystem.szAxis.font = font;
    m_view.chart.cartesianSystem.szAxis.color = axesColor;
    m_view.chart.cartesianSystem.szAxis.majorTicks.color = saxesColor;
    m_view.chart.cartesianSystem.szAxis.minorTicks.color = saxesColor;
    m_view.chart.cartesianSystem.szAlongX.color = saxesColor;
    m_view.chart.cartesianSystem.szAlongY.color = saxesColor;
    
    m_view.chart.cartesianSystem.borderColor = axesColor;
}

- (void)resetTransformationsIfNeeded
{
    BOOL shortenZ = [m_axesDataSource zAxisShouldBeShorter];
    
    if ((m_prevSeriesCount != self.seriesCount && (self.drawIn3D && (self.seriesType != NChart3DTypesPie &&
         self.seriesType != NChart3DTypesDoughnut))) || shortenZ != m_prevZAxisShouldBeShorter)
        [m_view.chart resetTransformations:TRANSITION_TIME];
    
    m_prevSeriesCount = self.seriesCount;
    m_prevZAxisShouldBeShorter = shortenZ;
}

- (void)createSeries
{
    [m_audioCapturer killDevice]; // This call waits until everything is done in streaming threads.
    
    [m_view.chart removeAllSeries];
    
    m_view.chart.drawIn3D = self.drawIn3D;
    
    m_view.chart.legend.visible = self.showLegend;
    
    m_view.chart.minZoom = m_view.chart.drawIn3D ? 0.5f : 1.0f;
    
    m_view.chart.cartesianSystem.margin = (m_view.chart.drawIn3D ? NChartMarginMake(50.0f, 50.0f, 10.0f, 10.0f) :
                                           NChartMarginMake(10.0f, 10.0f, 10.0f, 10.0f));
    
    m_view.chart.cartesianSystem.zAxis.shouldBeautifyMinAndMax = YES;

    [m_delegate resetPopup];
    
    [m_seriesDataSource createSeries];
    
    BOOL isStreaming = NO;
    
    switch (self.seriesType)
    {
        case NChart3DTypesStreamingArea:
        case NChart3DTypesStreamingColumn:
        case NChart3DTypesStreamingLine:
        case NChart3DTypesStreamingStep:
        case NChart3DTypesStreamingSurface:
        {
            if (!m_audioCapturer)
            {
                m_audioCapturer = [NChart3DAudioCapturer new];
                m_audioCapturer.delegate = self;
            }
            if ([m_audioCapturer initDevice])
                m_view.chart.caption.text = NSLocalizedString(@"Microphone spectrum", nil);
            else
                m_view.chart.caption.text = NSLocalizedString(@"Microphone spectrum <not working>", nil);
            m_audioCapturer.spectrumSize = m_audioCapturer.sampleRate * (m_view.chart.drawIn3D ? self.spectrum3DCount : self.spectrum2DCount) / 4000;
            isStreaming = YES;
            m_view.chart.legend.visible = NO;
            m_view.chart.cartesianSystem.zAxis.shouldBeautifyMinAndMax = NO;
        }
            break;
            
        default:
            break;
    }
    
    m_view.chart.pointSelectionEnabled = !isStreaming;
    
    [m_view.chart.timeAxis stop];
    [m_view.chart.timeAxis goToFirstTick];
    
    [m_view layoutLegend];
    
    [m_view.chart updateData];
    
    [m_view.chart stopTransition];
    
    if (!isStreaming)
        [m_view.chart playTransition:TRANSITION_TIME reverse:NO];
    
    [self resetTransformationsIfNeeded];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    
    if (isStreaming)
        [m_audioCapturer startCaptureSession];
}

- (void)rebuildSeries
{
    [m_view.chart rebuildSeries];
    
    [m_view.chart stopTransition];
    [m_view.chart playTransition:TRANSITION_TIME reverse:NO];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
}

#pragma mark - NChart3DAudioCapturerDelegate

- (void)audioCapturerSpectrumData:(const float *)spectrum withFFTSize:(int)fftSize
{
    if (m_audioCapturer.isInited)
    {
        [m_view.chart beginTransaction];
        NSArray *points = ((NChartSeries *)[m_view.chart.series lastObject]).points;
        if (self.seriesType == NChart3DTypesStreamingSurface)
        {
            for (int i = 0; i < self.spectrum3DCount; ++i)
            {
                for (int j = 1; j < self.spectrum3DCount - 1; ++j)
                {
                    ((NChartPoint *)points[i * self.spectrum3DCount + j]).currentState.doubleY = ((NChartPoint *)points[i * self.spectrum3DCount + j + 1]).currentState.doubleY;
                    ((NChartPoint *)points[i * self.spectrum3DCount + j]).currentState.brush = ((NChartPoint *)points[i * self.spectrum3DCount + j + 1]).currentState.brush;
                }
            }
            for (int i = 0; i < self.spectrum3DCount; ++i)
            {
                float s = sqrt(spectrum[i]);
                ((NChartPoint *)points[i * self.spectrum3DCount + self.spectrum3DCount - 2]).currentState.doubleY = s;
                ((NChartPoint *)points[i * self.spectrum3DCount + self.spectrum3DCount - 2]).currentState.brush = [NChartSolidColorBrush solidColorBrushWithColor:[m_seriesDataSource getInterpolatedColorWithRatio:1.0f - s / 0.2f]];
            }
        }
        else if (self.seriesType == NChart3DTypesStreamingColumn && self.drawIn3D)
        {
            int n = self.spectrum3DCount - 1;
            for (int i = 0; i < n; ++i)
            {
                for (int j = 0; j < n - 1; ++j)
                {
                    ((NChartPoint *)points[i * n + j]).currentState.doubleY = ((NChartPoint *)points[i * n + j + 1]).currentState.doubleY;
                    ((NChartPoint *)points[i * n + j]).currentState.brush = ((NChartPoint *)points[i * n + j + 1]).currentState.brush;
                }
            }
            for (int i = 0; i < n; ++i)
            {
                float s = sqrt(spectrum[i + 1]);
                ((NChartPoint *)points[i * n + n - 1]).currentState.doubleY = s;
                ((NChartPoint *)points[i * n + n - 1]).currentState.brush = [NChartSolidColorBrush solidColorBrushWithColor:[m_seriesDataSource getInterpolatedColorWithRatio:1.0f - s / 0.2f]];
            }
        }
        else if (self.drawIn3D)
        {
            int n = self.spectrum3DCount;
            NSArray *prevPoints;
            NSArray *nextPoints;
            for (int j = 0; j < n - 2; ++j)
            {
                prevPoints = ((NChartSeries *)[m_view.chart.series objectAtIndex:j]).points;
                nextPoints = ((NChartSeries *)[m_view.chart.series objectAtIndex:j + 1]).points;
                for (int i = 0; i < n; ++i)
                {
                    ((NChartPoint *)prevPoints[i]).currentState.doubleY = ((NChartPoint *)nextPoints[i]).currentState.doubleY;
                    ((NChartPoint *)prevPoints[i]).currentState.brush = ((NChartPoint *)nextPoints[i]).currentState.brush;
                }
            }
            for (int i = 0; i < n; ++i)
            {
                float s = sqrt(spectrum[i + 1]);
                ((NChartPoint *)nextPoints[i]).currentState.doubleY = s;
                ((NChartPoint *)nextPoints[i]).currentState.brush = [NChartSolidColorBrush solidColorBrushWithColor:[m_seriesDataSource getInterpolatedColorWithRatio:1.0f - s / 0.2f]];
            }
        }
        else
        {
            int i = 0;
            for (NChartPoint *point in points)
                point.currentState.doubleY = sqrt(spectrum[i++]);
        }
        [m_view.chart streamData];
        [m_view.chart endTransaction];
    }
}

@end
