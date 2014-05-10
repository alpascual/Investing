/**
 * This file is the part of NChart3D Framework
 * http://www.nchart3d.com
 *
 * File: NChartColumnSeries.h
 * Version: "1.3.8"
 *
 * Copyright (C) 2014 Nulana LTD. All Rights Reserved.
 */

#import "NChartSolidSeries.h"


/**
 * The NChartColumnSeries class provides methods to display column series.
 */
@interface NChartColumnSeries : NChartSolidSeries

@end

/**
 * NChartColumnSeriesSettings class provides global settings for <NChartColumnSeries>.
 */
@interface NChartColumnSeriesSettings : NChartSolidSeriesSettings

/**
 * The resolution of cylinders. Resolution is the amount of vertices that build the circle. For example if you want to 
 * get a square column, you should set resolution to 4. If you want to get a cylindrical column, you may set a larger
 * value. But the larger is the resolution, the more memory is used and the slower the rendering will be, so you should 
 * find out the minimal acceptable value. A good value for cylinder is 16 or 20. The default value is 4.
 * @note This value cannot be less than 3 and greater than 32.
 */
@property (nonatomic, assign) int cylindersResolution;

/**
 * Flag that determines if cylinders should appear smooth (YES) of faced (NO).  Generally if you specify low resolution 
 * \(see <cylindersResolution> for details\) when the individual faces are still visible, it is a good idea to have 
 * cylinders faced and vice versa. The default value is NO.
 * @note If cylinders are faced, it consumes more memory than if they don't by the same resolution.
 */
@property (nonatomic, assign) BOOL shouldSmoothCylinders;

@end
