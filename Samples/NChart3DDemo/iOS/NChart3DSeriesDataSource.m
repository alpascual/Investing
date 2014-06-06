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
            NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"chart2" ofType:@"csv"];
            
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
         
        // This is the scatter points AL
        case NChart3DTypesScatter:
        {
            
                for (int j = 0; j < m_mainViewController.seriesCount; ++j)
                {
                    NSMutableArray *states = [NSMutableArray array];
                    
                    for (int i = 0; i < self.fields.count; ++i)
                    {
                        NSArray *item = [self.fields objectAtIndex:i];
                        
                        //NSString *year = [item objectAtIndex:0];
                        //NSString *targetYear = [m_mainViewController.arrayOfYears objectAtIndex:j];
                        
                        //if ( [targetYear isEqualToString:year] == YES)
                        {
                            // Filter the tags
                            NSString *localTag = [item objectAtIndex:1];
                            NSString *tagName = [self.extractedSeries objectAtIndex:series.tag];
                            if ( [localTag isEqualToString:tagName] == YES)
                            {
                               // NSLog(@"year %@ with series %@", year, localTag);
                                double x = [[item objectAtIndex:2] doubleValue];
                                double y = [[item objectAtIndex:3] doubleValue];
                                double z = [[item objectAtIndex:4] doubleValue];
                                NChartPointState *state = [NChartPointState pointStateWithX:x Y:y Z:z];
                                state.size = 1.0f;
                                
                                state.shape = NChartMarkerShapeSphere;
                                state.brush = [[m_mainViewController.brushes objectAtIndex:(series.tag) % m_mainViewController.brushes.count] copy];
                                state.brush.shadingModel = NChartShadingModelPhong;
                                
                                //NSLog(@"Added state localTag %@ with tagName %@", localTag, tagName);
                                [states addObject:state];
                            }
                        }
                    }
                    
                    [result addObject:[NChartPoint pointWithArrayOfStates:states forSeries:series]];
                }
            
            

        }
            break;

    }
    
    return result;
}

- (NSString *)seriesDataSourceNameForSeries:(NChartSeries *)series
{
    return [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [self.extractedSeries objectAtIndex:series.tag] ];
    

}

@end
