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
 

#import "AxesTypesViewController.h"


@implementation AxesTypesViewController
{
    NChartView *m_view;
}

- (void)dealloc
{
    [m_view release];
    
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
    
    // Array of colors for the series.
    CGFloat colors[3][3] =
    {
        { 0.38f, 0.8f, 0.91f },
        { 0.79f, 0.86f, 0.22f },
        { 0.9f, 0.29f, 0.51f }
    };
    
    // Create column series with colors from the array and add them to the chart.
    for (int i = 0; i < 3; ++i)
    {
        NChartColumnSeries *series = [[NChartColumnSeries new] autorelease];
        series.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:colors[i][0]
                                                                                       green:colors[i][1]
                                                                                        blue:colors[i][2]
                                                                                       alpha:1.0f]];
        series.dataSource = self;
        
        // Tag is used to get data for a particular series in the data source.
        series.tag = i;
        
        [m_view.chart addSeries:series];
    }
    
    // Set data source for the X-Axis to have custom values on them.
    m_view.chart.cartesianSystem.xAxis.dataSource = self;
    
    // Set the type of value axes. Uncomment one of the following lines to see what heppens.
//    m_view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute; // Default absolute type.
//    m_view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAdditive; // Additive type.
//    m_view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypePercent; // Percent type.
    
    // Update data in the chart.
    [m_view.chart updateData];
    
    // Set chart view to the controller.
    self.view = m_view;
}

#pragma mark - NChartSeriesDataSource

- (NSArray *)seriesDataSourcePointsForSeries:(NChartSeries *)series
{
    // Create points with some data for the series.
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < 10; ++i)
    {
        [result addObject:[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:i Y:((rand() % 30) + 1)]
                                            forSeries:series]];
    }
    return result;
}

- (NSString *)seriesDataSourceNameForSeries:(NChartSeries *)series
{
    // Get the name of series.
    return [NSString stringWithFormat:@"My series %d", series.tag + 1];
}

#pragma mark - NChartValueAxisDataSource

- (NSArray *)valueAxisDataSourceTicksForValueAxis:(NChartValueAxis *)axis
{
    // Choose ticks by the kind of axis.
    switch (axis.kind)
    {
        case NChartValueAxisX:
        {
            // Return 10 ticks for the X-Axis representing, let us say, years.
            NSMutableArray *result = [NSMutableArray array];
            for (int i = 2000; i < 2010; ++i)
                [result addObject:[NSString stringWithFormat:@"%d", i]];
            return result;
        }
            
        default:
            // Other axes have no ticks.
            return nil;
    }
}

@end
