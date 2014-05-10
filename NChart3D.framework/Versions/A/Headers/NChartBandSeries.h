/**
 * This file is the part of NChart3D Framework
 * http://www.nchart3d.com
 *
 * File: NChartBandSeries.h
 * Version: "1.3.8"
 *
 * Copyright (C) 2014 Nulana LTD. All Rights Reserved.
 */
//
//  NChartBandSeries.h
//  NChart
//
//  Created by Evgeniy Chudinov on 11.11.13.
//
//

#import "NChartOHLCSeries.h"


/**
 * The NChartBandSeries class provides methods to display band series. This series type is for 2D only.
 */
@interface NChartBandSeries : NChartOHLCSeries

/**
 * Color for the low border.
 */
@property (nonatomic, retain) UIColor *lowBorderColor;

/**
 * Color for the high border.
 */
@property (nonatomic, retain) UIColor *highBorderColor;

@end

/**
 * The NChartBandSeriesSettings class provides global settings for <NChartBandSeries>.
 */
@interface NChartBandSeriesSettings : NChartOHLCSeriesSettings

@end
