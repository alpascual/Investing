/**
 * This file is the part of NChart3D Framework
 * http://www.nchart3d.com
 *
 * File: NChartLegend.h
 * Version: "1.3.8"
 *
 * Copyright (C) 2014 Nulana LTD. All Rights Reserved.
 */

#import "NChartLabel.h"


/**
 * The NChartLegend class provides methods to display the legend of the chart.
 */
@interface NChartLegend : NChartPlaced

/**
 * Font of the legend's text.
 */
@property (nonatomic, retain) UIFont *font;

/**
 * Color of the legend's text.
 */
@property (nonatomic, retain) UIColor *textColor;

/**
 * Label that is placed on the bottom of the legend. It's nil by default.
 * @see NChartLabel.
 */
@property (nonatomic, retain) NChartLabel *footer;

/**
 * Label that is placed on the top of the legend. It's nil by default.
 * @see NChartLabel.
 */
@property (nonatomic, retain) NChartLabel *header;

/**
 * Alignment of the legend. 
 * Please note, that if alignment is <code>NChartLegendBlockAlignmentLeft</code>, <code>NChartLegendBlockAlignmentRight</code>,
 * <code>NChartLegendBlockAlignmentBottom</code> or <code>NChartLegendBlockAlignmentTop</code>, the border radius is
 * ignored (assumed to be 0).
 * @see NChartLegendBlockAlignment.
 */
@property (nonatomic, assign) NChartLegendBlockAlignment blockAlignment;

/**
 * Alignment of legend's content in legend's area. The default value is <code>NChartLegendContentAlignmentCenter</code>.
 * @see NChartLegendContentAlignment.
 */
@property (nonatomic, assign) NChartLegendContentAlignment contentAlignment;

/**
 * Number of columns in legend. If 0 or less than 0, entries are aligned in lines with no columns.
 * The default value is 0.
 */
@property (nonatomic, assign) int columnCount;

/**
 * Maximal size of legend in pixels. The default value is 200. If the legend's block alignment is so that the legend
 * grows vertically, it is interpreted as maximal height, if the legend grows horizontally -- as maximal width. 
 * To be more precise, the mapping works as follows
 * - by <code>NChartLegendBlockAlignmentBottomLeft</code> it is height;
 * - by <code>NChartLegendBlockAlignmentBottomCenter</code> it is height;
 * - by <code>NChartLegendBlockAlignmentBottomRight</code> it is height;
 * - by <code>NChartLegendBlockAlignmentCenterLeft</code> it is width;
 * - by <code>NChartLegendBlockAlignmentCenterCenter</code> it is ignored;
 * - by <code>NChartLegendBlockAlignmentCenterRight</code> it is width;
 * - by <code>NChartLegendBlockAlignmentTopLeft</code> it is height;
 * - by <code>NChartLegendBlockAlignmentTopCenter</code> it is height;
 * - by <code>NChartLegendBlockAlignmentTopRight</code> it is height;
 * - by <code>NChartLegendBlockAlignmentLeft</code> it is width;
 * - by <code>NChartLegendBlockAlignmentRight</code> it is width;
 * - by <code>NChartLegendBlockAlignmentBottom</code> it is height;
 * - by <code>NChartLegendBlockAlignmentTop</code> it is height.
 */
@property (nonatomic, assign) float maxSize;

/**
 * Minimal padding between entries in pixels. The default value is 10.
 */
@property (nonatomic, assign) float minimalEntriesPadding;

/**
 * Padding inside the scroller.
 */
@property (nonatomic, assign) NChartMargin scrollerPadding;

/**
 * Orientation of the legend.
 * @see NChartLegendOrientation.
 */
@property (nonatomic, assign) NChartLegendOrientation orientation;

/**
 * Origin of the legend. It's a starting point that has effect only with orientation set to one of "free"-kinds.
 */
@property (nonatomic, assign) CGPoint origin;

@end
