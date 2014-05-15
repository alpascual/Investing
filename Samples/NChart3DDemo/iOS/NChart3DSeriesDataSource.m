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
 

#import "NChart3DSeriesDataSource.h"
#import "NChart3DMainViewController.h"
#import "NChart3DRegularData.h"
#import "NChart3DBubbleData.h"
#import "NChart3DCandlestickData.h"


@implementation NChart3DSeriesDataSource
{
    NChart3DMainViewController *m_mainViewController;
    NChart3DTypes m_prevSeriesType;
    BOOL m_prevDrawIn3D;
    NSArray *m_rainbowColors;
}

@synthesize rainbowColors = m_rainbowColors;

- (id)initWithMainViewController:(NChart3DMainViewController *)mainViewController
{
    self = [super init];
    if (self)
    {
        m_mainViewController = mainViewController;
    }
    return self;
}

- (void)createSeries
{
    NChartView *view = (NChartView *)m_mainViewController.view;
    
    if (m_prevSeriesType != m_mainViewController.seriesType || view.chart.drawIn3D != m_prevDrawIn3D)
    {
        [view.chart resetTransition];
        m_prevSeriesType = m_mainViewController.seriesType;
        m_prevDrawIn3D = view.chart.drawIn3D;
    }
    
    view.chart.cartesianSystem.zAxis.labelsVisible = YES;
    
    switch (m_mainViewController.seriesType)
    {
//        case NChart3DTypesColumn:
//        {
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartColumnSeries *series = [NChartColumnSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count];
//                if (m_mainViewController.showBorder)
//                {
//                    series.borderThickness = 1.01f;
//                    NChartBrush *borderBrush = [[m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count] copy];
//                    [borderBrush scaleColorWithRScale:0.65f gScale:0.65f bScale:0.65f];
//                    series.borderBrush = borderBrush;
//                }
//                [view.chart addSeries:series];
//            }
//            NChartColumnSeriesSettings *settings = [NChartColumnSeriesSettings seriesSettings];
//            settings.cylindersResolution = m_mainViewController.sliceCount;
//            settings.shouldSmoothCylinders = m_mainViewController.smoothColumn;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.syAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Column", nil);
//        }
//            break;
//            
//        case NChart3DTypesBar:
//        {
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartBarSeries *series = [NChartBarSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count];
//                if (m_mainViewController.showBorder)
//                {
//                    series.borderThickness = 1.01f;
//                    NChartBrush *borderBrush = [[m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count] copy];
//                    [borderBrush scaleColorWithRScale:0.65f gScale:0.65f bScale:0.65f];
//                    series.borderBrush = borderBrush;
//                }
//                [view.chart addSeries:series];
//            }
//            NChartBarSeriesSettings *settings = [NChartBarSeriesSettings seriesSettings];
//            settings.cylindersResolution = m_mainViewController.sliceCount;
//            settings.shouldSmoothCylinders = m_mainViewController.smoothColumn;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = YES;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Bar", nil);
//        }
//            break;
//            
//        case NChart3DTypesArea:
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartAreaSeries *series = [NChartAreaSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                NChartBrush *brush = [[m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count] copy];
//                brush.opacity = view.chart.drawIn3D ? 1.0f : 0.8f;
//                series.brush = brush;
//                if (m_mainViewController.showBorder)
//                {
//                    series.borderThickness = 3.0f;
//                    series.borderBrush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                }
//                if (m_mainViewController.showMarkers)
//                {
//                    series.marker = [[NChartMarker alloc] init];
//                    series.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
//                    series.marker.resolution = view.chart.drawIn3D ? 32 : 20;
//                    series.marker.size = 0.25f;
//                    series.marker.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                    series.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
//                }
//                [view.chart addSeries:series];
//            }
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Area", nil);
//            break;
//            
//        case NChart3DTypesLine:
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartLineSeries *series = [NChartLineSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                series.lineThickness = 3.0f;
//                if (m_mainViewController.showMarkers)
//                {
//                    series.marker = [[NChartMarker alloc] init];
//                    series.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
//                    series.marker.resolution = view.chart.drawIn3D ? 32 : 20;
//                    series.marker.size = 0.25f;
//                    series.marker.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                    series.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
//                }
//                [view.chart addSeries:series];
//            }
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Line", nil);
//            break;
//            
//        case NChart3DTypesStep:
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartStepSeries *series = [NChartStepSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                series.lineThickness = 3.0f;
//                if (m_mainViewController.showMarkers)
//                {
//                    series.marker = [[NChartMarker alloc] init];
//                    series.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
//                    series.marker.resolution = view.chart.drawIn3D ? 32 : 20;
//                    series.marker.size = 0.25f;
//                    series.marker.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                    series.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
//                }
//                [view.chart addSeries:series];
//            }
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Step line", nil);
//            break;
//            
//        case NChart3DTypesRibbon:
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartRibbonSeries *series = [NChartRibbonSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.contrastGradientBrushes objectAtIndex:i % m_mainViewController.contrastGradientBrushes.count];
//                if (m_mainViewController.showBorder)
//                {
//                    series.borderThickness = 2.0f;
//                    series.borderBrush = [m_mainViewController.contrastGradientBrushes objectAtIndex:i % m_mainViewController.contrastGradientBrushes.count];
//                }
//                if (m_mainViewController.showMarkers)
//                {
//                    series.marker = [[NChartMarker alloc] init];
//                    series.marker.shape = NChartMarkerShapeSphere;
//                    series.marker.resolution = 32;
//                    series.marker.size = 0.25f;
//                    series.marker.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                    series.marker.brush.shadingModel = NChartShadingModelPhong;
//                }
//                [view.chart addSeries:series];
//            }
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.drawIn3D = YES;
//            view.chart.caption.text = NSLocalizedString(@"Ribbon", nil);
//            break;
//            
//        case NChart3DTypesPie:
//        {
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartPieSeries *series = [NChartPieSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count];
//                if (m_mainViewController.showBorder)
//                {
//                    series.borderThickness = 2.0f;
//                    series.borderBrush = BrushWithRGB(0, 0, 0);
//                }
//                [view.chart addSeries:series];
//            }
//            NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
//            settings.holeRatio = 0.0f;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Pie", nil);
//        }
//            break;
//            
//        case NChart3DTypesDoughnut: {
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartPieSeries *series = [NChartPieSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count];
//                if (m_mainViewController.showBorder)
//                {
//                    series.borderThickness = 2.0f;
//                    series.borderBrush = BrushWithRGB(0, 0, 0);
//                }
//                [view.chart addSeries:series];
//            }
//            NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
//            settings.holeRatio = 0.1f;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Doughnut", nil);
//            break;
//            
//        }
//        case NChart3DTypesBubble:
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartBubbleSeries *series = [NChartBubbleSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                [view.chart addSeries:series];
//            }
//            view.chart.timeAxis.animationTime = (float)(m_mainViewController.yearsCount);
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = YES;
//            view.chart.caption.text = NSLocalizedString(@"Bubble", nil);
//            m_mainViewController.prevTimeIndex = 0;
//            break;
            
        // AL: here goes the series
        case NChart3DTypesScatter:
        {
            NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"GFD_DJIA_Companies" ofType:@"csv"];
            
            self.fields = [NSArray arrayWithContentsOfCSVFile:file options:CHCSVParserOptionsRecognizesBackslashesAsEscapes];
            
            self.extractedSeries = [self extractedSeries:self.fields];
            
            for (int i=0; i < self.extractedSeries.count; i++) {
                NChartBubbleSeries *series = [NChartBubbleSeries series];
                series.dataSource = self;
                series.tag = i;
                [view.chart addSeries:series];
            }
            
            view.chart.streamingMode = NO;
                        view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
                        view.chart.cartesianSystem.xAxis.hasOffset = NO;
                        view.chart.cartesianSystem.yAxis.hasOffset = NO;
                        view.chart.cartesianSystem.zAxis.hasOffset = NO;
                        view.chart.timeAxis.visible = YES;
                        view.chart.caption.text = NSLocalizedString(@"Scatter", nil);
            
        }
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartBubbleSeries *series = [NChartBubbleSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                [view.chart addSeries:series];
//            }
//            view.chart.timeAxis.animationTime = (float)(m_mainViewController.yearsCount);
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = YES;
//            view.chart.caption.text = NSLocalizedString(@"Scatter", nil);
//            m_mainViewController.prevTimeIndex = 0;
            break;
            
//        case NChart3DTypesSurface:
//        {
//            NChartSurfaceSeries *series = [NChartSurfaceSeries series];
//            series.dataSource = self;
//            series.tag = 0;
//            if (m_mainViewController.showBorder)
//            {
//                series.borderThickness = 0.5f;
//            }
//            [view.chart addSeries:series];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Surface", nil);
//            view.chart.drawIn3D = YES;
//        }
//            break;
//            
//        case NChart3DTypesCandlestick:
//        {
//            for (int i = 0, m = (m_mainViewController.drawIn3D ? m_mainViewController.seriesCount : 1); i < m; ++i)
//            {
//                NChartCandlestickSeries *series = [NChartCandlestickSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.positiveColor = ColorWithRGB(73, 226, 141);
//                series.positiveBorderColor = ColorWithRGB(65, 204, 38);
//                series.negativeColor = ColorWithRGB(221, 73, 73);
//                series.negativeBorderColor = ColorWithRGB(199, 15, 50);
//                series.borderThickness = 3.0f;
//                [view.chart addSeries:series];
//            }
//            NChartCandlestickSeriesSettings *settings = [NChartCandlestickSeriesSettings seriesSettings];
//            settings.cylindersResolution = MAX((int)exp2((-log2(MAX(m_mainViewController.seriesCount, m_mainViewController.yearsCount)) * 2.0 / 5.0 + 6.0)), 16);
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Candlestick", nil);
//        }
//            break;
//            
//        case NChart3DTypesOHLC:
//            for (int i = 0, m = (m_mainViewController.drawIn3D ? m_mainViewController.seriesCount : 1); i < m; ++i)
//            {
//                NChartOHLCSeries *series = [NChartOHLCSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.positiveColor = ColorWithRGB(73, 226, 141);
//                series.negativeColor = ColorWithRGB(221, 73, 73);
//                series.borderThickness = 3.0f * (m_mainViewController.yearsCount > 10 ? 1.0f : 10.0f / (float)m_mainViewController.yearsCount);
//                [view.chart addSeries:series];
//            }
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"OHLC", nil);
//            break;
//            
//        case NChart3DTypesBand:
//        {
//            NChartBandSeries *series = [NChartBandSeries series];
//            series.dataSource = self;
//            series.tag = 0;
//            series.brush = [m_mainViewController.brushes objectAtIndex:0];
//            series.positiveColor = [UIColor colorWithRed:0.41f green:0.67f blue:0.95f alpha:0.8f];
//            series.negativeColor = [UIColor colorWithRed:0.77f green:0.94f blue:0.36f alpha:0.8f];
//            series.highBorderColor = [UIColor colorWithRed:0.51f green:0.78f blue:1.0f alpha:0.8f];
//            series.lowBorderColor = [UIColor colorWithRed:0.89f green:1.0f blue:0.44f alpha:0.8f];
//            series.borderThickness = 5.0f;
//            [view.chart addSeries:series];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.drawIn3D = NO;
//            view.chart.caption.text = NSLocalizedString(@"Band", nil);
//        }
//            break;
//            
//        case NChart3DTypesSequence:
//            for (int i = 0, m = m_mainViewController.seriesCount; i < m; ++i)
//            {
//                NChartSequenceSeries *series = [NChartSequenceSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.brushes objectAtIndex:i % m_mainViewController.brushes.count];
//                [view.chart addSeries:series];
//            }
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = YES;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = NO;
//            view.chart.drawIn3D = NO;
//            view.chart.caption.text = NSLocalizedString(@"Sequence", nil);
//            break;
//            
//        case NChart3DTypesPieRotation:
//        {
//            for (int i = 0; i < m_mainViewController.seriesCount; ++i)
//            {
//                NChartPieSeries *series = [NChartPieSeries series];
//                series.dataSource = self;
//                series.tag = i;
//                series.brush = [m_mainViewController.gradientBrushes objectAtIndex:i % m_mainViewController.gradientBrushes.count];
//                if (m_mainViewController.showBorder)
//                {
//                    ((NChartPieSeries *)series).borderThickness = 2.0f;
//                    ((NChartPieSeries *)series).borderBrush = BrushWithRGB(0, 0, 0);
//                }
//                else
//                {
//                    ((NChartPieSeries *)series).borderThickness = 0.0f;
//                }
//                [view.chart addSeries:series];
//            }
//            NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
//            settings.holeRatio = 0.0f;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.timeAxis.visible = NO;
//            view.chart.drawIn3D = YES;
//            view.chart.caption.text = NSLocalizedString(@"Rotation of pie, tap play to see animation", nil);
//        }
//            break;
//            
//        case NChart3DTypesMultichart:
//        {
//            NChartAreaSeries *series1 = [NChartAreaSeries series];
//            view.chart.drawIn3D = YES;
//            series1.dataSource = self;
//            series1.tag = 0;
//            series1.brush = [m_mainViewController.gradientBrushes objectAtIndex:0];
//            series1.borderBrush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor blackColor]];
//            series1.borderThickness = 1;
//            [view.chart addSeries:series1];
//            
//            NChartColumnSeries *series2 = [NChartColumnSeries series];
//            series2.dataSource = self;
//            series2.tag = 1;
//            series2.brush = [m_mainViewController.gradientBrushes objectAtIndex:7];
//            [view.chart addSeries:series2];
//            
//            NChartLineSeries *series3 = [NChartLineSeries series];
//            series3.dataSource = self;
//            series3.tag = 2;
//            series3.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0 green:0.6 blue:0.2 alpha:1]];
//            series3.lineThickness = 3;
//            series3.marker = [[NChartMarker alloc] init];
//            series3.marker.shape = NChartMarkerShapeSphere;
//            series3.marker.resolution = 32;
//            series3.marker.size = 0.25f;
//            series3.marker.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor redColor]];
//            series3.marker.brush.shadingModel = NChartShadingModelPhong;
//            [view.chart addSeries:series3];
//            
//            NChartColumnSeriesSettings *settings = [NChartColumnSeriesSettings seriesSettings];
//            settings.cylindersResolution = 4;
//            settings.shouldSmoothCylinders = NO;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = YES;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.syAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = YES;
//            view.chart.timeAxis.visible = NO;
//            view.chart.caption.text = NSLocalizedString(@"Multichart, tap point to see animation", nil);
//        }
//            break;
//            
//        case NChart3DTypesStreamingColumn:
//        {
//            NChartSolidSeries *series = [NChartColumnSeries series];
//            
//            series.dataSource = self;
//            series.tag = 0;
//            series.brush = [m_mainViewController.gradientBrushes objectAtIndex:0];
//            [view.chart addSeries:series];
//            
//            view.chart.drawIn3D = m_mainViewController.drawIn3D;
//            
//            NChartColumnSeriesSettings *settings = [NChartColumnSeriesSettings seriesSettings];
//            settings.cylindersResolution = 4;
//            settings.shouldSmoothCylinders = NO;
//            [view.chart addSeriesSettings:settings];
//            view.chart.streamingMode = YES;
//            view.chart.legend.visible = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.syAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = NO;
//            view.chart.cartesianSystem.zAxis.labelsVisible = NO;
//        }
//            break;
//            
//        case NChart3DTypesStreamingArea:
//        case NChart3DTypesStreamingLine:
//        case NChart3DTypesStreamingStep:
//        {
//            for (int i = 0, m = m_mainViewController.drawIn3D ? m_mainViewController.spectrum3DCount - 1 : 1; i < m; ++i)
//            {
//                NChartSolidSeries *series;
//                if (m_mainViewController.seriesType == NChart3DTypesStreamingArea)
//                    series = [NChartAreaSeries series];
//                if (m_mainViewController.seriesType == NChart3DTypesStreamingLine)
//                    series = [NChartLineSeries series];
//                if (m_mainViewController.seriesType == NChart3DTypesStreamingStep)
//                    series = [NChartStepSeries series];
//                
//                series.dataSource = self;
//                series.tag = m_mainViewController.drawIn3D ? i + 1 : 0;
//                series.brush = [m_mainViewController.gradientBrushes objectAtIndex:0];
//                [view.chart addSeries:series];
//            }
//            
//            view.chart.drawIn3D = m_mainViewController.drawIn3D;
//            
//            view.chart.streamingMode = YES;
//            view.chart.legend.visible = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.syAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = NO;
//            view.chart.cartesianSystem.zAxis.labelsVisible = NO;
//        }
//            break;
//            
//        case NChart3DTypesStreamingSurface:
//        {
//            NChartSurfaceSeries *series = [NChartSurfaceSeries series];
//            series.dataSource = self;
//            series.tag = 0;
//            series.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor grayColor]];
//            [view.chart addSeries:series];
//            view.chart.streamingMode = YES;
//            view.chart.legend.visible = NO;
//            view.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
//            view.chart.cartesianSystem.xAxis.hasOffset = NO;
//            view.chart.cartesianSystem.yAxis.hasOffset = NO;
//            view.chart.cartesianSystem.zAxis.hasOffset = NO;
//            view.chart.timeAxis.visible = NO;
//            view.chart.drawIn3D = YES;
//            view.chart.cartesianSystem.zAxis.labelsVisible = NO;
//        }
//            break;
    }
}

- (void)applyColorSchemeToSeries
{
    NChartView *view = (NChartView *)m_mainViewController.view;
    
    if (m_mainViewController.seriesType >= NChart3DTypesMultichart)
        return;
    
    for (NChartSeries *series in view.chart.series)
    {
        if ([series isKindOfClass:[NChartColumnSeries class]])
        {
            NChartColumnSeries *columnSeries = (NChartColumnSeries *)series;
            columnSeries.brush = [m_mainViewController.gradientBrushes objectAtIndex:series.tag % m_mainViewController.gradientBrushes.count];
            if (m_mainViewController.showBorder)
            {
                columnSeries.borderThickness = 1.01f;
                NChartBrush *borderBrush = [[m_mainViewController.gradientBrushes
                                              objectAtIndex:series.tag % m_mainViewController.gradientBrushes.count] copy];
                [borderBrush scaleColorWithRScale:0.65f gScale:0.65f bScale:0.65f];
                columnSeries.borderBrush = borderBrush;
            }
            else
            {
                columnSeries.borderThickness = 0.0f;
            }
        }
        else if ([series isKindOfClass:[NChartAreaSeries class]])
        {
            NChartAreaSeries *areaSeries = (NChartAreaSeries *)series;
            NChartBrush *brush = [[m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count] copy];
            brush.opacity = view.chart.drawIn3D ? 1.0f : 0.8f;
            areaSeries.brush = brush;
            if (m_mainViewController.showBorder)
            {
                areaSeries.borderThickness = 3.0f;
                areaSeries.borderBrush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
            }
            else
            {
                areaSeries.borderThickness = 0.0f;
            }
            if (m_mainViewController.showMarkers)
            {
                areaSeries.marker = [[NChartMarker alloc] init];
                areaSeries.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
                areaSeries.marker.resolution = view.chart.drawIn3D ? 32 : 20;
                areaSeries.marker.size = 0.25f;
                areaSeries.marker.brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
                areaSeries.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
            }
            else
            {
                areaSeries.marker = nil;
            }
        }
        else if ([series isKindOfClass:[NChartLineSeries class]])
        {
            NChartLineSeries *lineSeries = (NChartLineSeries *)series;
            lineSeries.brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
            lineSeries.lineThickness = 3.0f;
            if (m_mainViewController.showMarkers)
            {
                lineSeries.marker = [[NChartMarker alloc] init];
                lineSeries.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
                lineSeries.marker.resolution = view.chart.drawIn3D ? 32 : 20;
                lineSeries.marker.size = 0.25f;
                lineSeries.marker.brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
                lineSeries.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
            }
            else
            {
                lineSeries.marker = nil;
            }
        }
        else if ([series isKindOfClass:[NChartStepSeries class]])
        {
            NChartStepSeries *stepSeries = (NChartStepSeries *)series;
            stepSeries.brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
            stepSeries.lineThickness = 3.0f;
            if (m_mainViewController.showMarkers)
            {
                stepSeries.marker = [[NChartMarker alloc] init];
                stepSeries.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
                stepSeries.marker.resolution = view.chart.drawIn3D ? 32 : 20;
                stepSeries.marker.size = 0.25f;
                stepSeries.marker.brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
                stepSeries.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
            }
            else
            {
                stepSeries.marker = nil;
            }
        }
        else if ([series isKindOfClass:[NChartRibbonSeries class]])
        {
            NChartRibbonSeries *ribbonSeries = (NChartRibbonSeries *)series;
            ribbonSeries.brush = [m_mainViewController.contrastGradientBrushes
                                  objectAtIndex:series.tag % m_mainViewController.contrastGradientBrushes.count];
            if (m_mainViewController.showBorder)
            {
                ribbonSeries.borderThickness = 2.0f;
                ribbonSeries.borderBrush = [m_mainViewController.contrastGradientBrushes
                                            objectAtIndex:series.tag % m_mainViewController.contrastGradientBrushes.count];
            }
            else
            {
                ribbonSeries.borderThickness = 0.0f;
            }
            if (m_mainViewController.showMarkers)
            {
                ribbonSeries.marker = [[NChartMarker alloc] init];
                ribbonSeries.marker.shape = view.chart.drawIn3D ? NChartMarkerShapeSphere : NChartMarkerShapeCircle;
                ribbonSeries.marker.resolution = view.chart.drawIn3D ? 32 : 20;
                ribbonSeries.marker.size = 0.25f;
                ribbonSeries.marker.brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
                ribbonSeries.marker.brush.shadingModel = view.chart.drawIn3D ? NChartShadingModelPhong : NChartShadingModelPlain;
            }
            else
            {
                ribbonSeries.marker = nil;
            }
        }
        else if ([series isKindOfClass:[NChartPieSeries class]])
        {
            ((NChartPieSeries *)series).brush = [m_mainViewController.gradientBrushes
                                                 objectAtIndex:series.tag % m_mainViewController.gradientBrushes.count];
            if (m_mainViewController.showBorder)
            {
                ((NChartPieSeries *)series).borderThickness = 2.0f;
                ((NChartPieSeries *)series).borderBrush = BrushWithRGB(0, 0, 0);
            }
            else
            {
                ((NChartPieSeries *)series).borderThickness = 0.0f;
            }
        }
        else if ([series isKindOfClass:[NChartBubbleSeries class]])
        {
        }
        else if ([series isKindOfClass:[NChartSequenceSeries class]])
        {
            ((NChartSequenceSeries *)series).brush = [m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count];
        }
        else if ([series isKindOfClass:[NChartSurfaceSeries class]])
        {
            ((NChartSurfaceSeries *)series).borderThickness = m_mainViewController.showBorder ? 0.5f : 0.0f;
        }
    }
    
    [view.chart updateSeries];
}

- (NSArray *)rainbowColors
{
    if (m_rainbowColors.count == 0)
    {
        NSMutableArray *result = [NSMutableArray array];
        //[result addObject:[m_mainViewController.brushes[2] color]];
        [result addObject:[UIColor redColor]];
        [result addObject:[m_mainViewController.brushes[7] color]];
        [result addObject:[m_mainViewController.brushes[1] color]];
        [result addObject:[m_mainViewController.brushes[4] color]];
        [result addObject:[m_mainViewController.brushes[0] color]];
        [result addObject:[m_mainViewController.brushes[3] color]];
        [result addObject:[m_mainViewController.brushes[8] color]];
        self.rainbowColors = result;
    }
    return m_rainbowColors;
}

- (UIColor *)colorLerpFrom:(UIColor *)start
                        to:(UIColor *)end
              withDuration:(float)t
{
    const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(end.CGColor);
    
    float startAlpha = CGColorGetAlpha(start.CGColor);
    float endAlpha = CGColorGetAlpha(end.CGColor);
    
    float r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
    float g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
    float b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
    float a = startAlpha + (endAlpha - startAlpha) * t;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (NSArray*) extractedSeries:(NSArray*)myCSV
{
    NSString *lastTag = @"";
    
    NSMutableArray *tags = [NSMutableArray new];
    for (int i=0; i<myCSV.count; i++)
    {
        NSArray *temp = [myCSV objectAtIndex:i];
        if ( temp.count > 1)
        {
            NSString *tag = [temp objectAtIndex:1];
            if ( [tag isEqualToString:lastTag] == NO)
            {
                [tags addObject:tag];
                lastTag = tag;
            }
        }
    }
    
    return tags;
}

- (UIColor *)getInterpolatedColorWithRatio:(float)ratio
{
    float nRatio = ratio * (float)(self.rainbowColors.count - 1);
    if (ratio <= 0.0f)
        return [self.rainbowColors firstObject];
    else if (ratio >= 1.0f)
        return [self.rainbowColors lastObject];
    int numberOfFirst = (int)(nRatio);
    int numberOfSecond = (int)(nRatio) + 1;
    float durarion = nRatio - (int)nRatio;
    return [self colorLerpFrom:self.rainbowColors[numberOfFirst] to:self.rainbowColors[numberOfSecond] withDuration:durarion];
}

#pragma mark - NChartSeriesDataSource

#define Z_COUNT 4
#define SURFACE_RES 75
#define LISSAJOU_RES 10

// ALL here goes the data more info here
// http://www.nchart3d.com/nchart-doc/tutorial.html
- (NSArray *)seriesDataSourcePointsForSeries:(NChartSeries *)series
{
    NSMutableArray *result = [NSMutableArray array];
    
    NChartView *view = (NChartView *)m_mainViewController.view;
    
    switch (m_mainViewController.seriesType)
    {
//        case NChart3DTypesColumn:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                for (int j = 0, m = view.chart.drawIn3D ? Z_COUNT : 1; j < m; ++j)
//                {
//                    [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                                   pointStateAlignedToXZWithX:i
//                                                                   Y:g_regularData[series.tag][i][j]
//                                                                   Z:j]
//                                                        forSeries:series]];
//                }
//            }
//            break;
//            
//        case NChart3DTypesBar:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                for (int j = 0, m = view.chart.drawIn3D ? Z_COUNT : 1; j < m; ++j)
//                {
//                    [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                                   pointStateAlignedToYZWithX:g_regularData[series.tag][i][j]
//                                                                   Y:i
//                                                                   Z:j]
//                                                        forSeries:series]];
//                }
//            }
            break;
            
//        case NChart3DTypesArea:
//        case NChart3DTypesLine:
//        case NChart3DTypesStep:
//        case NChart3DTypesRibbon:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                               pointStateAlignedToXZWithX:i
//                                                               Y:g_regularData[series.tag][i][series.tag % Z_COUNT]
//                                                               Z:view.chart.drawIn3D &&
//                                                               (view.chart.cartesianSystem.valueAxesType ==
//                                                                NChartValueAxesTypeAbsolute) ? series.tag : 0]
//                                                    forSeries:series]];
//            }
//            break;
//            
//        case NChart3DTypesPie:
//        case NChart3DTypesDoughnut:
//        case NChart3DTypesPieRotation:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                               pointStateWithCircle:i
//                                                               value:g_regularData[series.tag][i][0]]
//                                                    forSeries:series]];
//            }
//            break;
//            
//        case NChart3DTypesBubble:
//        {
//            NSMutableArray *states = [NSMutableArray array];
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                NChartPointState *state = [NChartPointState pointStateWithX:g_bubbleData[series.tag][i][0]
//                                                                          Y:g_bubbleData[series.tag][i][1]
//                                                                          Z:g_bubbleData[series.tag][i][2]];
//                state.size = g_bubbleData[series.tag][i][3];
//                if (!view.chart.drawIn3D)
//                {
//                    state.shape = NChartMarkerShapeCircle;
//                    state.brush = [[m_mainViewController.brushes objectAtIndex:(series.tag + i) % m_mainViewController.brushes.count] copy];
//                    state.brush.shadingModel = NChartShadingModelPlain;
//                    state.brush.opacity = 0.8f;
//                    if (m_mainViewController.showBorder)
//                    {
//                        state.borderBrush = [[m_mainViewController.brushes objectAtIndex:(series.tag + i) % m_mainViewController.brushes.count] copy];
//                        [state.borderBrush scaleColorWithRScale:0.85f gScale:0.85f bScale:0.85f];
//                        state.borderThickness = 2.0f;
//                    }
//                }
//                else
//                {
//                    state.shape = NChartMarkerShapeSphere;
//                    state.brush = [[m_mainViewController.brushes objectAtIndex:(series.tag + i) % m_mainViewController.brushes.count] copy];
//                    state.brush.shadingModel = NChartShadingModelPhong;
//                }
//                [states addObject:state];
//            }
//            [result addObject:[NChartPoint pointWithArrayOfStates:states forSeries:series]];
//        }
//            break;
         
        // This is the scatter points AL
        case NChart3DTypesScatter:
        {
            
            //NSLog(@"read: %@", fields);
            
//            NSString *yearTag = [m_mainViewController.arrayOfYears objectAtIndex:series.tag]; // AL: TODO make sure you have the number of years first in the series
//            
//            for ( int i=0; i < self.fields.count; i++)
//            {
//                NSArray *item = [self.fields objectAtIndex:i];
//                
//                if ( item.count > 1)
//                {
//                    NSString *localTag = [item objectAtIndex:1];
//                    
//                    if ( [localTag isEqualToString:yearTag] == YES)
//                    {
//                        double x = [[item objectAtIndex:2] doubleValue];
//                        double y = [[item objectAtIndex:3] doubleValue];
//                        double z = [[item objectAtIndex:4] doubleValue];
//                        NChartPointState *state = [NChartPointState pointStateWithX:x Y:y Z:z];
//                        
//                        // Setting the brush
//                        state.shape = NChartMarkerShapeSphere;
//                        state.brush = [[m_mainViewController.brushes objectAtIndex:(series.tag) % m_mainViewController.brushes.count] copy];
//                        state.brush.shadingModel = NChartShadingModelPhong;
//                        
//                        NChartPoint *point = [NChartPoint pointWithState:state forSeries:series];
//                        
//                        [result addObject:point];
//                        //[result addObject:point forSeries:series]];
//                    }
//                }
//            }
            
            //[result addObject:[NChartPoint pointWithArrayOfStates:states forSeries:series]];
            

            // AL: This one
//            NSString *tagName = [self.extractedSeries objectAtIndex:series.tag];
//            
//            for ( int i=0; i < self.fields.count; i++)
//            {
//                NSArray *item = [self.fields objectAtIndex:i];
//                
//                if ( item.count > 1)
//                {
//                    NSString *localTag = [item objectAtIndex:1];
//                    
//                    if ( [localTag isEqualToString:tagName] == YES)
//                    {
//                        double x = [[item objectAtIndex:2] doubleValue];
//                        double y = [[item objectAtIndex:3] doubleValue];
//                        double z = [[item objectAtIndex:4] doubleValue];
//                        NChartPointState *state = [NChartPointState pointStateWithX:x Y:y Z:z];
//                        
//                        // Setting the brush
//                        state.shape = NChartMarkerShapeSphere;
//                        state.brush = [[m_mainViewController.brushes objectAtIndex:(series.tag) % m_mainViewController.brushes.count] copy];
//                        state.brush.shadingModel = NChartShadingModelPhong;
//                        
//                        NChartPoint *point = [NChartPoint pointWithState:state forSeries:series];
//                        
//                        [result addObject:point];
//                        //[result addObject:point forSeries:series]];
//                    }
//                }
//            }
            
            
            
            
            
            for (int i = 0; i <= LISSAJOU_RES; ++i)
            {
                NSMutableArray *states = [NSMutableArray array];
                for (int j = 0; j < m_mainViewController.yearsCount; ++j)
                {
                    double t = (((2.0 * M_PI) / (double)(LISSAJOU_RES * m_mainViewController.seriesCount)) *
                                (double)(i * m_mainViewController.seriesCount + series.tag + j * 2));
                    double x = sin(3.0 * t);
                    double y = sin(4.0 * t);
                    double z = sin(7.0 * t);
                    NChartPointState *state = [NChartPointState pointStateWithX:x Y:y Z:z];
                    state.size = 1.0f;
                    if (!view.chart.drawIn3D)
                    {
                        state.shape = NChartMarkerShapeCircle;
                        state.brush = [[m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count] copy];
                        state.brush.shadingModel = NChartShadingModelPlain;
                        state.brush.opacity = 0.8f;
                        if (m_mainViewController.showBorder)
                        {
                            state.borderBrush = [[m_mainViewController.brushes objectAtIndex:series.tag % m_mainViewController.brushes.count] copy];
                            [state.borderBrush scaleColorWithRScale:0.85f gScale:0.85f bScale:0.85f];
                            state.borderThickness = 2.0f;
                        }
                    }
                    else
                    {
                        state.shape = NChartMarkerShapeSphere;
                        state.brush = [[m_mainViewController.brushes objectAtIndex:(series.tag + j) % m_mainViewController.brushes.count] copy];
                        state.brush.shadingModel = NChartShadingModelPhong;
                    }
                    [states addObject:state];
                }
                [result addObject:[NChartPoint pointWithArrayOfStates:states forSeries:series]];
            }
        }
            break;
            
//        case NChart3DTypesSurface:
//        {
//            double y = 0.0, minY = -1.0, maxY = 1.0, normalY;
//            double x, z;
//            float minRed, minGreen, minBlue, maxRed, maxGreen, maxBlue;
//            switch (m_mainViewController.functionType)
//            {
//                case NChart3DFunctionType1:
//                    minY = -1.0, maxY = 1.0;
//                    minRed = 36.0 / 255.0; minGreen = 136.0 / 255.0; minBlue = 201.0 / 255.0;
//                    maxRed = 122.0 / 255.0; maxGreen = 254.0 / 255.0; maxBlue = 254.0 / 255.0;
//                    break;
//                    
//                case NChart3DFunctionType2:
//                    minY = -1.5; maxY = 1.5;
//                    minRed = 169.0 / 255.0; minGreen = 115.0 / 255.0; minBlue = 0.0 / 255.0;
//                    maxRed = 233.0 / 255.0; maxGreen = 225.0 / 255.0; maxBlue = 0.0 / 255.0;
//                    break;
//                    
//                case NChart3DFunctionType3:
//                    minY = 1.0; maxY = 9.0;
//                    minRed = 193.0 / 255.0; minGreen = 0.0 / 255.0; minBlue = 82.0 / 255.0;
//                    maxRed = 237.0 / 255.0; maxGreen = 114.0 / 255.0; maxBlue = 236.0 / 255.0;
//                    break;
//                    
//                case NChart3DFunctionType5:
//                    minY = -1.0; maxY = 1.0;
//                    minRed = 57.0 / 255.0; minGreen = 29.0 / 255.0; minBlue = 199.0 / 255.0;
//                    maxRed = 129.0 / 255.0; maxGreen = 199.0 / 255.0; maxBlue = 255.0 / 255.0;
//                    break;
//                    
//                case NChart3DFunctionType4:
//                    minY = -1.0; maxY = 1.0;
//                    minRed = 18.0 / 255.0; minGreen = 161.0 / 255.0; minBlue = 3.0 / 255.0;
//                    maxRed = 89.0 / 255.0; maxGreen = 255.0 / 255.0; maxBlue = 168.0 / 255.0;
//                    break;
//                    
//                case NChart3DFunctionType6:
//                    minY = -1.0; maxY = 1.0;
//                    minRed = 199.0 / 255.0; minGreen = 35.0 / 255.0; minBlue = 7.0 / 255.0;
//                    maxRed = 255.0 / 255.0; maxGreen = 161.0 / 255.0; maxBlue = 124.0 / 255.0;
//                    break;
//                    
//                case NChart3DFunctionType7:
//                    minY = -1.0; maxY = 1.0;
//                    minRed = 137.0 / 255.0; minGreen = 16.0 / 255.0; minBlue = 197.0 / 255.0;
//                    maxRed = 222.0 / 255.0; maxGreen = 168.0 / 255.0; maxBlue = 255.0 / 255.0;
//                    break;
//                    
//                default:
//                    break;
//            }
//            for (int i = 0, n = SURFACE_RES; i < n; ++i)
//            {
//                for (int j = 0, m = SURFACE_RES; j < m; ++j)
//                {
//                    switch (m_mainViewController.functionType)
//                    {
//                        case NChart3DFunctionType1:
//                            x = (double)(i) * 2.0 * M_PI / (double)n;
//                            z = (double)(j) * 2.0 * M_PI / (double)m;
//                            y = sin(x) * cos(z);
//                            break;
//                            
//                        case NChart3DFunctionType2:
//                            x =  6.0 * (2.0 * (double)(i) / (double)(n) - 1.0);
//                            z = -6.0 * (2.0 * (double)(j) / (double)(m) - 1.0);
//                            y = 1.5 * atan(x * z) / (maxY - minY);
//                            break;
//                            
//                        case NChart3DFunctionType3:
//                            x = 4.0 * (double)(i) / (double)(n) - 2.0;
//                            z = 4.0 * (double)(j) / (double)(m) - 2.0;
//                            y = (x * x + z * z - maxY / 2.0) / (maxY - minY) * 1.5;
//                            break;
//                            
//                        case NChart3DFunctionType4:
//                            x = 1.0 - fabs(1.0 - 2.0 * (double)(i) / (double)(n));
//                            z = 1.0 - 2.0 * (double)(j) / (double)(m);
//                            y = sin(x * M_PI / 2.0) * cos(z * M_PI * 2.0);
//                            break;
//                            
//                        case NChart3DFunctionType5:
//                            z = 2.0 * (double)(j) / (double)(m) - 1.0;
//                            x = 2.0 * (double)(i) / (double)(n) - 1.0;
//                            double r = sqrt(x * x + z * z);
//                            // double fi = atan2(x * M_PI, z * M_PI);
//                            y = cos(r * M_PI * 4.0) * exp(-1.5 * r - 1.0);
//                            break;
//                            
//                        case NChart3DFunctionType6:
//                            z = 1.0 - 2.0 * (double)(j) / (double)(m);
//                            y = 0.3 * sin(z * M_PI * 4.0) + z;
//                            break;
//                            
//                        case NChart3DFunctionType7:
//                            x = fabs(1.0 - 2.0 * (double)(i) / (double)(n));
//                            z = fabs(1.0 - 2.0 * (double)(j) / (double)(m));
//                            y = (1.0 - x * z) * 0.3 * sin((1.0 - x * z) * M_PI * 4.0);
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                    //                    if ((i - n / 2) * (i - n / 2) + (j - n / 2) * (j - n / 2) > (SURFACE_RES / 2) * (SURFACE_RES / 2) ||
//                    //                        (i - n * 2 / 7) * (i - n * 2 / 7) + (j - n * 2 / 7) * (j - n * 2 / 7) < (SURFACE_RES / 9) * (SURFACE_RES / 9) ||
//                    //                        (i - n * 5 / 7) * (i - n * 5 / 7) + (j - n * 2 / 7) * (j - n * 2 / 7) < (SURFACE_RES / 9) * (SURFACE_RES / 9) ||
//                    //                        (
//                    //                         (i - n / 2) * (i - n / 2) + (j - n / 9) * (j - n / 9) < (SURFACE_RES * 10 / 15) * (SURFACE_RES * 10 / 15) &&
//                    //                         (i - n / 2) * (i - n / 2) + (j + n / 9) * (j + n / 9) > (SURFACE_RES * 13 / 15) * (SURFACE_RES * 13 / 15) &&
//                    //                         (i > n / 6 && i < n * 5 / 6)
//                    //                        )
//                    //                        )
//                    //                        continue;
//                    
//                    NChartPointState *state = [NChartPointState pointStateWithX:i Y:y Z:j];
//                    normalY = (y + 1.0) / 2.0;
//                    state.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor
//                                                                                   colorWithRed:(1.0 - normalY) * minRed + normalY * maxRed
//                                                                                   green:(1.0 - normalY) * minGreen + normalY * maxGreen
//                                                                                   blue:(1.0 - normalY) * minBlue + normalY * maxBlue
//                                                                                   alpha:1.0f]];
//                    NChartBrush *borderBrush = [state.brush copy];
//                    [borderBrush scaleColorWithRScale:0.65f gScale:0.65f bScale:0.65f];
//                    state.borderBrush = borderBrush;
//                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                }
//            }
//        }
//            break;
//            
//        case NChart3DTypesOHLC:
//        case NChart3DTypesCandlestick:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                double low = g_candlestickData[series.tag][i][0];
//                double open = g_candlestickData[series.tag][i][1];
//                double close = g_candlestickData[series.tag][i][2];
//                double high = g_candlestickData[series.tag][i][3];
//                [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                               pointStateAlignedToXZWithX:i
//                                                               Z:view.chart.drawIn3D ? series.tag : 0
//                                                               low:low
//                                                               open:open
//                                                               close:close
//                                                               high:high]
//                                                    forSeries:series]];
//            }
//            break;
//            
//        case NChart3DTypesBand:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                double low = g_candlestickData[series.tag][i][1];
//                double high = g_candlestickData[series.tag][i][2];
//                [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                               pointStateAlignedToXWithX:i
//                                                               low:low
//                                                               high:high]
//                                                    forSeries:series]];
//            }
//            break;
//            
//        case NChart3DTypesSequence:
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                int y = ((int)g_candlestickData[series.tag][i][0]) % 4;
//                double open = g_candlestickData[series.tag][i][1];
//                double close = open + 1.0;
//                [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                               pointStateAlignedToYWithY:y
//                                                               open:open
//                                                               close:close]
//                                                    forSeries:series]];
//            }
//            break;
//            
//        case NChart3DTypesMultichart:
//        {
//            const float data[3][5] = { { 4.0f, 2.5f, 3.0f, 2.8f, 3.5f }, { 1.0f, 1.5f, 2.0f, 2.5f, 3.0f }, { 0.5f, 2.0f, 1.0f, 1.5f, 2.5f } };
//            for (int i = 0; i < m_mainViewController.yearsCount; ++i)
//            {
//                [result addObject:[NChartPoint pointWithState:[NChartPointState
//                                                               pointStateAlignedToXZWithX:i
//                                                               Y:data[series.tag][i % 5] + (series.tag < 2 ? 1 : 0)
//                                                               Z:series.tag]
//                                                    forSeries:series]];
//            }
//        }
//            break;
//            
//        case NChart3DTypesStreamingColumn:
//            if (m_mainViewController.drawIn3D)
//            {
//                int step = m_mainViewController.spectrumStep;
//                for (int i = 1; i < m_mainViewController.spectrum3DCount; ++i)
//                {
//                    for (int j = 1; j < m_mainViewController.spectrum3DCount; ++j)
//                    {
//                        NChartPointState *state = [NChartPointState
//                                                   pointStateAlignedToXZWithX:i * step
//                                                   Y:0.0
//                                                   Z:j];
//                        state.brush = [NChartSolidColorBrush solidColorBrushWithColor:[self.rainbowColors lastObject]];
//                        [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                    }
//                }
//            }
//            else
//            {
//                int step = m_mainViewController.spectrumStep;
//                for (int i = 0; i < m_mainViewController.spectrum2DCount; ++i)
//                {
//                    NChartPointState *state = [NChartPointState
//                                               pointStateAlignedToXZWithX:i * step
//                                               Y:0.0
//                                               Z:series.tag];
//                    float t = (float)i / (float)m_mainViewController.spectrum2DCount;
//                    UIColor *color = [self getInterpolatedColorWithRatio:t];
//                    state.brush = [NChartSolidColorBrush solidColorBrushWithColor:color];
//                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                }
//            }
//            break;
//            
//        case NChart3DTypesStreamingArea:
//        case NChart3DTypesStreamingLine:
//        case NChart3DTypesStreamingStep:
//            {
//                if (m_mainViewController.drawIn3D)
//                {
//                    int step = m_mainViewController.spectrumStep;
//                    for (int i = 0; i < m_mainViewController.spectrum3DCount; ++i)
//                    {
//                        NChartPointState *state = [NChartPointState pointStateAlignedToXZWithX:i * step Y:0.0 Z:series.tag];
//                        state.brush = [NChartSolidColorBrush solidColorBrushWithColor:[self.rainbowColors lastObject]];
//                        [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                    }
//                }
//                else
//                {
//                    int step = m_mainViewController.spectrumStep;
//                    for (int i = 0; i < m_mainViewController.spectrum2DCount; ++i)
//                    {
//                        NChartPointState *state = [NChartPointState pointStateAlignedToXZWithX:i * step Y:0.0 Z:series.tag];
//                        float t = (float)i / (float)m_mainViewController.spectrum2DCount;
//                        UIColor *color = [self getInterpolatedColorWithRatio:t];
//                        state.brush = [NChartSolidColorBrush solidColorBrushWithColor:color];
//                        [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                    }
//                }
//                break;
//            }
//            break;
//            
//        case NChart3DTypesStreamingSurface:
//        {
//            int step = m_mainViewController.spectrumStep;
//            for (int i = 0; i < m_mainViewController.spectrum3DCount; ++i)
//            {
//                for (int j = 0; j < m_mainViewController.spectrum3DCount; ++j)
//                {
//                    NChartPointState *state = [NChartPointState
//                                               pointStateAlignedToXZWithX:i * step
//                                               Y:0.0
//                                               Z:j];
//                    state.brush = [NChartSolidColorBrush solidColorBrushWithColor:[self.rainbowColors lastObject]];
//                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                }
//            }
//        }
//            break;
    }
    
    return result;
}

- (NSString *)seriesDataSourceNameForSeries:(NChartSeries *)series
{
    return [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [self.extractedSeries objectAtIndex:series.tag] ];
    
    
//    if (m_mainViewController.seriesType != NChart3DTypesSurface)
//        return [NSString stringWithFormat:NSLocalizedString(@"Series %d", nil), series.tag + 1];
//    else
//        switch (m_mainViewController.functionType)
//    {
//        case NChart3DFunctionType1:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = sin(a·x)·cos(b·z)", nil)];
//            
//        case NChart3DFunctionType2:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = a·atan(b·x·z)", nil)];
//            
//        case NChart3DFunctionType3:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = a·(x²+z²)", nil)];
//            
//        case NChart3DFunctionType4:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = sin(a·x)·cos(b·z)", nil)];
//            
//        case NChart3DFunctionType5:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = a·cos(b·(x²+z²))·exp(c·(x²+z²))", nil)];
//            
//        case NChart3DFunctionType6:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = a·sin(b·x)+c·z", nil)];
//            
//        case NChart3DFunctionType7:
//            return [NSString stringWithFormat:NSLocalizedString(@"y = a·(1-x·z)·sin(1-x·z)", nil)];
//            
//        default:
//            return nil;
//    }
}

@end
