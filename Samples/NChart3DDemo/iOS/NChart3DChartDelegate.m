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
 

#import "NChart3DChartDelegate.h"
#import "NChart3DMainViewController.h"


@interface NChart3DChartDelegate()

@property (nonatomic, strong) NChartPoint *prevSelectedPoint;
@property (nonatomic, strong) NChartSeries *prevSelectedSeries;

@end

@implementation NChart3DChartDelegate
{
    NChart3DMainViewController *m_mainViewController;
    float m_prevZoom;
}

- (id)initWithMainViewController:(NChart3DMainViewController *)mainViewController
{
    self = [super init];
    if (self)
    {
        m_mainViewController = mainViewController;
        m_prevZoom = 1.0f;
    }
    return self;
}


- (NChartTooltip *)createTooltip
{
    NChartTooltip *result = [NChartTooltip new];
    result.visible = NO;
    
    switch (m_mainViewController.colorScheme) {
        case NChart3DColorSchemeLight:
        case NChart3DColorSchemeSimple:
            result.background = BrushWithRGB(255, 255, 255);
            result.background.opacity = 0.9f;
            result.padding = NChartMarginMake(10.0f, 10.0f, 10.0f, 10.0f);
            result.borderColor = ColorWithRGB(130, 130, 130);
            result.borderThickness = 1.0f;
            result.font = FontWithSize(16.0f);
            break;
            
        case NChart3DColorSchemeDark:
        case NChart3DColorSchemeTextured:
            result.background = BrushWithRGB(44, 44, 44);
            result.background.opacity = 0.9f;
            result.padding = NChartMarginMake(10.0f, 10.0f, 10.0f, 10.0f);
            result.borderColor = ColorWithRGB(80, 80, 80);
            result.borderThickness = 1.0f;
            result.font = FontWithSize(16.0f);
            result.textColor = [UIColor whiteColor];
            break;
    }
    
    return result;
}

- (double)processDoubleValue:(double)value
{
    return fabs(value) < 1.0e-3 ? 0.0 : value;
}

- (void)updateTooltipText:(NChartPoint *)point
{
    switch (m_mainViewController.seriesType)
    {
        case NChart3DTypesColumn:
        case NChart3DTypesArea:
        case NChart3DTypesLine:
        case NChart3DTypesStep:
        case NChart3DTypesRibbon:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nYear = %@\nValue = %.2f", nil),
                                  point.series.name, [m_mainViewController.arrayOfYears objectAtIndex:point.currentState.intX],
                                  [self processDoubleValue:point.currentState.doubleY]];
            break;
            
        case NChart3DTypesBar:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nValue = %.2f\nYear = %@", nil),
                                  point.series.name, [self processDoubleValue:point.currentState.doubleX],
                                  [m_mainViewController.arrayOfYears objectAtIndex:point.currentState.intY]];
            break;
            
        case NChart3DTypesPie:
        case NChart3DTypesDoughnut:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nYear = %@\nValue = %.2f", nil),
                                  point.series.name, [m_mainViewController.arrayOfYears objectAtIndex:point.currentState.circle],
                                  [self processDoubleValue:point.currentState.value]];
            break;
            
        case NChart3DTypesBubble:
        case NChart3DTypesScatter:
            if (m_mainViewController.drawIn3D)
            {
                point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nX = %.2f\nY = %.2f\nZ = %.2f", nil),
                                      point.series.name, [self processDoubleValue:point.currentState.doubleX],
                                      [self processDoubleValue:point.currentState.doubleY],
                                      [self processDoubleValue:point.currentState.doubleZ]];
            }
            else
            {
                point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nX = %.2f\nY = %.2f", nil),
                                      point.series.name, [self processDoubleValue:point.currentState.doubleX],
                                      [self processDoubleValue:point.currentState.doubleY]];
            }
            break;
            
        case NChart3DTypesCandlestick:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nOpen = %.2f\nClose = %.2f\nLow = %.2f\nHigh = %.2f", nil),
                                  point.series.name, [self processDoubleValue:point.currentState.open],
                                  [self processDoubleValue:point.currentState.close],
                                  [self processDoubleValue:point.currentState.low],
                                  [self processDoubleValue:point.currentState.high]];
            break;
            
        case NChart3DTypesOHLC:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nOpen = %.2f\nClose = %.2f\nLow = %.2f\nHigh = %.2f", nil),
                                  point.series.name, [self processDoubleValue:point.currentState.open],
                                  [self processDoubleValue:point.currentState.close],
                                  [self processDoubleValue:point.currentState.low],
                                  [self processDoubleValue:point.currentState.high]];
            break;
            
        case NChart3DTypesBand:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nLow = %.2f\nHigh = %.2f", nil),
                                  point.series.name, [self processDoubleValue:point.currentState.low],
                                  [self processDoubleValue:point.currentState.high]];
            break;
            
        case NChart3DTypesSequence:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nOpen = %.2f\nClose = %.2f", nil),
                                  point.series.name, [self processDoubleValue:point.currentState.open],
                                  [self processDoubleValue:point.currentState.close]];
            break;
            
        case NChart3DTypesSurface:
            point.tooltip.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nX = %.2f\nY = %.2f\nZ = %.2f", nil),
                                  point.series.name, [self processDoubleValue:point.currentState.doubleX],
                                  [self processDoubleValue:point.currentState.doubleY],
                                  [self processDoubleValue:point.currentState.doubleZ]];
            break;
            
        default:
            break;
    }
}

- (NChartTooltip *)createLabel
{
    NChartTooltip *result = [NChartTooltip new];
    result.visible = NO;
    
    switch (m_mainViewController.colorScheme) {
        case NChart3DColorSchemeLight:
        case NChart3DColorSchemeSimple:
            result.background = BrushWithRGB(255, 255, 255);
            result.background.opacity = 0.7f;
            result.padding = NChartMarginMake(5.0f, 5.0f, 5.0f, 5.0f);
            result.font = FontWithSize(16.0f);
            result.textColor = [UIColor blackColor];
            break;
            
        case NChart3DColorSchemeDark:
        case NChart3DColorSchemeTextured:
            result.background = BrushWithRGB(44, 44, 44);
            result.background.opacity = 0.7f;
            result.padding = NChartMarginMake(5.0f, 5.0f, 5.0f, 5.0f);
            result.font = FontWithSize(16.0f);
            result.textColor = [UIColor whiteColor];
            break;
    }
    
    return result;
}

- (void)updateLabelText:(NChartPoint *)point
{
    switch (m_mainViewController.seriesType)
    {
        case NChart3DTypesColumn:
        case NChart3DTypesArea:
        case NChart3DTypesLine:
        case NChart3DTypesStep:
        case NChart3DTypesRibbon:
            point.label.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f", nil),
                                [self processDoubleValue:point.currentState.doubleY]];
            break;
            
        case NChart3DTypesBar:
            point.label.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f", nil),
                                [self processDoubleValue:point.currentState.doubleX]];
            break;
            
        case NChart3DTypesBubble:
        case NChart3DTypesScatter:
            point.label.text = [NSString stringWithFormat:NSLocalizedString(@"%@", nil),
                                point.series.name];
            break;
            
        default:
            // Not allowed.
            break;
    }
}

- (void)resetPopup
{
    [self.prevSelectedPoint highlightWithMask:NChartHighlightTypeNone | NChartHighlightDrop duration:0.0f delay:0.0f];
    self.prevSelectedPoint = nil;
    self.prevSelectedSeries = nil;
    
    NChart3DView *view = (NChart3DView *)m_mainViewController.view;
    
    if (view.isZoomed)
    {
        [view.chart zoomTo:m_prevZoom duration:0.0f delay:0.0f];
        view.isZoomed = NO;
    }
    
    for (NChartSeries *series in view.chart.series)
    {
        for (NChartPoint *point in series.points)
        {
            if (point.tooltip)
            {
                point.tooltip.visible = NO;
                point.tooltip = nil;
            }
            if (point.label)
            {
                point.label.visible = NO;
                point.label = nil;
            }
        }
    }
}

#pragma mark - NChartDelegate

- (void)chartDelegateTimeIndexOfChart:(NChart *)chart changedTo:(double)timeIndex
{
    if (m_mainViewController.prevTimeIndex != (int)timeIndex)
    {
        m_mainViewController.prevTimeIndex = (int)timeIndex;
        if (self.prevSelectedPoint)
            [self updateTooltipText:self.prevSelectedPoint];
    }
}

- (void)chartDelegatePointOfChart:(NChart *)chart selected:(NChartPoint *)point
{
    if (m_mainViewController.seriesType == NChart3DTypesPieRotation)
        return;
    
    if (m_mainViewController.seriesType == NChart3DTypesMultichart &&
        ([point.series isKindOfClass:NChartColumnSeries.class] || [point.series isKindOfClass:NChartLineSeries.class]))
    {
        float delay = 0.0f;
        float duration = TRANSITION_TIME / 3.0f;
        UIColor *color = [point.series isKindOfClass:NChartColumnSeries.class] ? [UIColor redColor] : [UIColor yellowColor];
        for (NChartPoint *p in point.series.points)
        {
            p.highlightColor = color;
            [p highlightWithMask:NChartHighlightTypeColor duration:duration delay:delay];
            [p highlightWithMask:NChartHighlightTypeNone duration:duration * 2.0f delay:0.0f];
            delay += duration;
        }
        
        return;
    }
    
    NChart3DView *view = (NChart3DView *)m_mainViewController.view;
    
    BOOL shouldZoom = NO;
    
    [self.prevSelectedPoint.tooltip setVisible:NO animated:0.25f];
    if (point == self.prevSelectedPoint || point.series != self.prevSelectedSeries)
        for (NChartPoint *p in self.prevSelectedSeries.points)
            [p.label setVisible:NO animated:0.25f];
    [self.prevSelectedPoint highlightWithMask:NChartHighlightTypeNone | NChartHighlightDrop duration:0.5f delay:0.0f];
    
    // Tooltip
    if (point && !m_mainViewController.showLabels)
    {
        if (point.tooltip)
        {
            if (point != self.prevSelectedPoint)
            {
                [self updateTooltipText:point];
                [point.tooltip setVisible:YES animated:0.25f];
            }
        }
        else
        {
            point.tooltip = [self createTooltip];
            [self updateTooltipText:point];
            [point.tooltip setVisible:YES animated:0.25f];
        }
        
    }
    
    // Label
    if (point && m_mainViewController.showLabels)
    {
        
        if (point.label)
        {
            if (point.series != self.prevSelectedSeries)
            {
                for (NChartPoint *p in point.series.points)
                {
                    [self updateLabelText:p];
                    [p.label setVisible:YES animated:0.25f];
                }
            }
        }
        else
        {
            for (NChartPoint *p in point.series.points)
            {
                p.label = [self createLabel];
                [self updateLabelText:p];
                [p.label setVisible:YES animated:0.25f];
            }
        }
    }
    
    // Highlight
    if (point)
    {
        if (point.series != self.prevSelectedSeries)
            self.prevSelectedSeries = point.series;
        else if (point == self.prevSelectedPoint)
            self.prevSelectedSeries = nil;
        
        if (point == self.prevSelectedPoint)
            self.prevSelectedPoint = nil;
        else
        {
            self.prevSelectedPoint = point;
            point.highlightShift = 0.2f;
            point.highlightColor = [UIColor redColor];
            [point highlightWithMask:NChartHighlightTypeShift | NChartHighlightTypeColor | NChartHighlightDrop
                            duration:0.5f
                               delay:0.0f];
            shouldZoom = (m_mainViewController.seriesType == NChart3DTypesPie || m_mainViewController.seriesType == NChart3DTypesDoughnut);
        }
    }
    else
    {
        self.prevSelectedPoint = nil;
        self.prevSelectedSeries = nil;
    }
    
    if (shouldZoom)
    {
        if (!view.isZoomed)
        {
            m_prevZoom = view.chart.zoom;
            float desiredZoom = m_prevZoom * 0.85f;
            if (view.chart.minZoom > desiredZoom)
                view.chart.minZoom = desiredZoom;
            [view.chart zoomTo:desiredZoom duration:0.25f delay:0.0f];
            view.isZoomed = YES;
        }
    }
    else if (view.isZoomed)
    {
        [view.chart zoomTo:m_prevZoom duration:0.25f delay:0.0f];
        view.isZoomed = NO;
    }
}

- (void)chartDelegateChartObject:(id)object didEndAnimating:(NChartAnimationType)animation
{
    // nop
}

@end
