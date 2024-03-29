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
 

#import "HighlightViewController.h"


@implementation HighlightViewController
{
    NChartView *m_view;
    BOOL m_zoomed;
}

- (void)dealloc
{
    [m_view release];
    self.brushes = nil;
    self.prevSelectedPoint = nil;
    
    [super dealloc];
}

- (void)loadView
{
    // Create a chart view that will display the chart.
    m_view = [[NChartView alloc] initWithFrame:CGRectZero];
    
    // Paste your license key here.
    m_view.chart.licenseKey = @"";
    
    // Margin to ensure some free space for the iOS status bar.
    m_view.chart.cartesianSystem.margin = NChartMarginMake(10.0f, 10.0f, 10.0f, 20.0f);
    
    // Create brushes.
    self.brushes = [NSMutableArray array];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.38f green:0.8f blue:0.91f alpha:1.0f]]];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.8f green:0.86f blue:0.22f alpha:1.0f]]];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.9f green:0.29f blue:0.51f alpha:1.0f]]];
    
    for (int i = 0; i < 3; ++i)
    {
        // Create series that will be displayed on the chart.
        NChartPieSeries *series = [NChartPieSeries series];
        
        // Set data source for the series.
        series.dataSource = self;
        
        // Set tag of the series.
        series.tag = i;
        
        // Set brush that will fill that series with color.
        series.brush = [self.brushes objectAtIndex:i % self.brushes.count];
        
        // Add series to the chart.
        [m_view.chart addSeries:series];
    }
    
    // Update data in the chart.
    [m_view.chart updateData];
    
    // Set delegate to the chart.
    m_view.chart.delegate = self;
    
    // Set chart view to the controller.
    self.view = m_view;
    
    // We set the minimal zoom to 0.85 (its default is 1.0) because we will
    // then shift the highlighted sectors of the pie away from the center.
    // We need to zoom out the pie to prevent the shifted sectors from hiding
    // behind the screen's border.
    // If the minimal zoom is larger than the zoom we set by zoomTo:duration:delay:,
    // chart will be bounced back to the minimal zoom immediately.
    m_view.chart.minZoom = 0.85f;
    m_zoomed = NO;
    
    // Uncomment this line to get the animated transition.
//    [m_view.chart playTransition:1.0f reverse:NO];
}

#pragma mark - NChartDelegate

- (void)chartDelegatePointOfChart:(NChart *)chart selected:(NChartPoint *)point
{
    // Disable highlight.
    [self.prevSelectedPoint highlightWithMask:NChartHighlightTypeNone duration:0.25f delay:0.0f];
    
    if (point)
    {
        if (point == self.prevSelectedPoint)
        {
            self.prevSelectedPoint = nil;
            
            // Return to normal zoom.
            if (m_zoomed)
            {
                m_zoomed = NO;
                [m_view.chart zoomTo:1.0f duration:0.25f delay:0.0f];
            }
        }
        else
        {
            self.prevSelectedPoint = point;
            
            if (!m_zoomed)
            {
                m_zoomed = YES;
                [m_view.chart zoomTo:0.85f duration:0.25f delay:0.0f];
            }
            
            // Set shift to highlight.
            point.highlightShift = 0.2f;
            
            // Set color to highlight.
            point.highlightColor = [UIColor redColor];
            
            // Highlight point by shift and color.
            [point highlightWithMask:NChartHighlightTypeShift | NChartHighlightTypeColor duration:0.25f delay:0.0f];
        }
    }
    else
    {
        self.prevSelectedPoint = nil;
        
        // Return to normal zoom.
        if (m_zoomed)
        {
            m_zoomed = NO;
            [m_view.chart zoomTo:1.0f duration:0.25f delay:0.0f];
        }
    }
}

- (void)chartDelegateTimeIndexOfChart:(NChart *)chart changedTo:(double)timeIndex
{
    // Do nothing, this demo does not cover the changing of the time index.
}

- (void)chartDelegateChartObject:(id)object didEndAnimating:(NChartAnimationType)animation
{
    // Do nothing, this demo requires no catching of animation ending.
}

#pragma mark - NChartSeriesDataSource

- (NSArray *)seriesDataSourcePointsForSeries:(NChartSeries *)series
{
    // Create points with some data for the series.
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[NChartPoint pointWithState:[NChartPointState pointStateWithCircle:0 value:(rand() % 30) + 1]
                                        forSeries:series]];
    return result;
}

- (NSString *)seriesDataSourceNameForSeries:(NChartSeries *)series
{
    // Get name of the series.
    return [NSString stringWithFormat:NSLocalizedString(@"Series %d", nil), series.tag + 1];
}

@end
