/**
 * This file is the part of NChart3D Framework
 * http://www.nchart3d.com
 *
 * File: NChartBrush.h
 * Version: "1.3.8"
 *
 * Copyright (C) 2014 Nulana LTD. All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "NChartTypes.h"


/**
 * The NChartBrush class provides common methods of the brush that can be used to fill some areas.
 */
@interface NChartBrush : NSObject <NSCopying>

/**
 * Scale components of brush's colors (if any) by given values. Each component of each color is multiplied by a
 * corresponding scale factor.
 *
 * @param rScale - scale for the red component.
 * @param gScale - scale for the green component.
 * @param bScale - scale for the blue component.
 */
- (void)scaleColorWithRScale:(float)rScale gScale:(float)gScale bScale:(float)bScale;

/**
 * Opacity of the brush in interval 0..1, 0 -- full transparency, 1 -- full opacity. The default value is 1.
 */
@property (nonatomic, assign) float opacity;

/**
 * Shading model that should be applied to an object if it's painted with this brush. You should understand
 * that different shading models are not always supported. For example, if you paint some background with the brush,
 * only plain shading (read -- no shading) is possible. But if you paint some 3d-object, different models can be
 * chosen (it is possible to draw this object as if it was lightened by some light source).
 * @see NChartShadingModel.
 */
@property (nonatomic, assign) NChartShadingModel shadingModel;

@end
