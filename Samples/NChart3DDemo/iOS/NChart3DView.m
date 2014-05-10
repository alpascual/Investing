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
 

#import "NChart3DView.h"

@implementation NChart3DView

- (void)layoutLegend
{
    CGSize maxEntrySize = CGSizeZero;
    for (NChartSeries *series in self.chart.series)
    {
        NSString *seriesName = [series.dataSource seriesDataSourceNameForSeries:series];
        CGSize size = [seriesName sizeWithFont:self.chart.legend.font];
        size.width += (self.chart.legend.minimalEntriesPadding * 2.0f + series.legendMarkerSize +
                       self.chart.legend.font.pointSize);
        if (maxEntrySize.width < size.width)
            maxEntrySize.width = size.width;
        if (maxEntrySize.height < size.height + self.chart.legend.minimalEntriesPadding)
            maxEntrySize.height = size.height + self.chart.legend.minimalEntriesPadding;
        if (maxEntrySize.height < series.legendMarkerSize + self.chart.legend.minimalEntriesPadding)
            maxEntrySize.height = series.legendMarkerSize + self.chart.legend.minimalEntriesPadding;
    }
    if (isIPhone() && UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        self.chart.legend.blockAlignment = NChartLegendBlockAlignmentLeft;
        if (maxEntrySize.height > 0.0f)
            self.chart.legend.columnCount = 1;
        if (maxEntrySize.width > 0.0f)
        {
            self.chart.legend.maxSize = (maxEntrySize.width * 1.0f + // We want to have maximal 1 lines displayed
                                         self.chart.legend.padding.left + self.chart.legend.padding.right -
                                         self.chart.legend.minimalEntriesPadding);
        }
    }
    else
    {
        self.chart.legend.blockAlignment = NChartLegendBlockAlignmentBottom;
        if (maxEntrySize.width > 0.0f)
        {
            int columnCount = ((self.bounds.size.width - self.chart.legend.padding.left - self.chart.legend.padding.right) /
                               maxEntrySize.width);
            self.chart.legend.columnCount = columnCount < self.chart.series.count ? columnCount : self.chart.series.count;
        }
        if (maxEntrySize.height > 0.0f)
        {
            self.chart.legend.maxSize = (maxEntrySize.height * 3.0f + // We want to have maximal 3 lines displayed
                                         self.chart.legend.padding.bottom + self.chart.legend.padding.top -
                                         self.chart.legend.minimalEntriesPadding);
        }
    }
}

- (void)layoutSubviews
{
    [self layoutLegend];
    self.isZoomed = NO;
    
    [super layoutSubviews];
}

@end

