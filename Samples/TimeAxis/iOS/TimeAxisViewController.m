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
 

#import "TimeAxisViewController.h"


@implementation TimeAxisViewController
{
    NChartView *m_view;
}

- (void)dealloc
{
    [m_view release];
    self.brushes = nil;
    
    [super dealloc];
}

- (void)loadView
{
    // Create a chart view that will display the chart.
    m_view = [[NChartView alloc] initWithFrame:CGRectZero];
    
    // Paste your license key here.
    m_view.chart.licenseKey = @"";
    
    // Margin to ensure some free space for iOS status bar.
    m_view.chart.cartesianSystem.margin = NChartMarginMake(10.0f, 10.0f, 10.0f, 20.0f);
    
    // Create brushes.
    self.brushes = [NSMutableArray array];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.38f green:0.8f blue:0.91f alpha:1.0f]]];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.8f green:0.86f blue:0.22f alpha:1.0f]]];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.9f green:0.29f blue:0.51f alpha:1.0f]]];
    
    // Set up the time axis.
    m_view.chart.timeAxis.tickShape = NChartTimeAxisTickShapeLine;
    m_view.chart.timeAxis.tickTitlesFont = [UIFont boldSystemFontOfSize:11.0f];
    m_view.chart.timeAxis.tickTitlesLayout = NChartTimeAxisShowFirstLastLabelsOnly;
    m_view.chart.timeAxis.tickTitlesPosition = NChartTimeAxisLabelsBeneath;
    m_view.chart.timeAxis.tickTitlesColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.0f];
    m_view.chart.timeAxis.tickColor = [UIColor colorWithRed:0.43f green:0.43f blue:0.43f alpha:1.0f];
    m_view.chart.timeAxis.margin = NChartMarginMake(20.0f, 20.0f, 10.0f, 0.0f);
    m_view.chart.timeAxis.autohideTooltip = NO;
    
    // Create the time axis tooltip.
    m_view.chart.timeAxis.tooltip = [NChartTimeAxisTooltip new];
    m_view.chart.timeAxis.tooltip.textColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.0f];
    m_view.chart.timeAxis.tooltip.font = [UIFont systemFontOfSize:11.0f];

    // Set images for the time axis.
    [self setImagesForTimeAxisSlider:@"slider-light.png"
                             handler:@"handler-light.png"
                          playNormal:@"play-light.png"
                          playPushed:@"play-pushed-light.png"
                         pauseNormal:@"pause-light.png"
                         pausePushed:@"pause-pushed-light.png"];
    
    // Visible time axis.
    m_view.chart.timeAxis.visible = YES;
    
    // Set animation time in seconds.
    m_view.chart.timeAxis.animationTime = 3.0f;
    
    // Switch 3D on.
    m_view.chart.drawIn3D = YES;
    
    // Switch on antialiasing.
    m_view.chart.shouldAntialias = YES;
    
    // Create series.
    for (int i = 0; i < 3; ++i)
    {
        NChartBubbleSeries *series = [NChartBubbleSeries series];
        series.dataSource = self;
        series.tag = i;
        // Add series to the chart.
        [m_view.chart addSeries:series];
    }
    m_view.chart.cartesianSystem.xAxis.hasOffset = NO;
    m_view.chart.cartesianSystem.yAxis.hasOffset = NO;
    m_view.chart.cartesianSystem.zAxis.hasOffset = NO;
    
    // Set data source for the size axis to provide ticks.
    m_view.chart.timeAxis.dataSource = self;
    
    // Set data source for the size axis to provide sizes for bubbles.
    m_view.chart.sizeAxis.dataSource = self;
    
    // Reset animation.
    [m_view.chart.timeAxis stop];
    [m_view.chart.timeAxis goToFirstTick];
    
    // Update data in the chart.
    [m_view.chart updateData];
    
    // Set chart view to the controller.
    self.view = m_view;
}

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

#pragma mark - NChartSeriesDataSource

- (NSArray *)seriesDataSourcePointsForSeries:(NChartSeries *)series
{
    // Create points with some data for the series.
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < 3; ++i)
    {
        NSMutableArray *states = [NSMutableArray array];
        for (int j = 0; j < 3; ++j)
        {
            NChartPointState *state = [NChartPointState pointStateWithX:(rand() % 10) + 1
                                                                      Y:(rand() % 10) + 1
                                                                      Z:(rand() % 10) + 1];
            state.size = (float)(rand() % 1000) / 1000.0f;
            state.brush = (NChartSolidColorBrush *)self.brushes[series.tag];
            state.shape = NChartMarkerShapeSphere;
            state.brush.shadingModel = NChartShadingModelPhong;
            [states addObject:state];
        }
        [result addObject:[NChartPoint pointWithArrayOfStates:states forSeries:series]];
    }
    return result;
}

- (NSString *)seriesDataSourceNameForSeries:(NChartSeries *)series
{
    // Get name of the series.
    return @"My series";
}

#pragma mark - NChartTimeAxisDataSource

- (NSArray *)timeAxisDataSourceTimestampsForAxis:(NChartTimeAxis *)timeAxis
{
    return @[@"1", @"2", @"3"];
}

#pragma mark - NChartSizeAxisDataSource

- (float)sizeAxisDataSourceMinSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Minimal size of bubbles in pixels. The size provided in the chart point is mapped to pixels through this value.
    return 30.0f;
}

- (float)sizeAxisDataSourceMaxSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Maximal size of bubbles in pixels. The size provided in the chart point is mapped to pixels through this value.
    return 100.0f;
}

@end
