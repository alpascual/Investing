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
 

#import <UIKit/UIKit.h>
#import "NChart3DVSplitViewController.h"
#import "NChart3DSettingsViewController.h"
#import "NChart3DView.h"
#ifdef NCHART3D_SOURCES
#import "NChart3D.h"
#else
#import <NChart3D/NChart3D.h>
#endif // NCHART3D_SOURCES
#import "NChart3DTypes.h"
#import "NChart3DAudioCapturer.h"
#import "NChart3DAxesDataSource.h"
#import "NChart3DSeriesDataSource.h"
#import "NChart3DChartDelegate.h"
#import "NChart3DMainViewControllerDelegate.h"

#define TRANSITION_TIME 0.5f

#define FontWithSize(s) /*[UIFont fontWithName:@"Helvetica" size:s]*/ [UIFont systemFontOfSize:s]

#define BoldFontWithSize(s) /*[UIFont fontWithName:@"Helvetica-Bold" size:s]*/ [UIFont boldSystemFontOfSize:s]

#define ColorWithRGB(r, g, b) [UIColor colorWithRed:(CGFloat)(r) / 255.0f \
                                              green:(CGFloat)(g) / 255.0f \
                                               blue:(CGFloat)(b) / 255.0f \
                                              alpha:1.0f]

#define BrushWithRGB(r, g, b) [NChartSolidColorBrush solidColorBrushWithColor:ColorWithRGB(r, g, b)]

#define GradientBrushWithRGB(r1, g1, b1, r2, g2, b2)                                 \
    [NChartLinearGradientBrush linearGradientBrushFromColor:ColorWithRGB(r1, g1, b1) \
                                                    toColor:ColorWithRGB(r2, g2, b2)]


@interface NChart3DMainViewController : UIViewController <UIAlertViewDelegate,
                                                          NChart3DSettingsDelegate,
                                                          NChart3DAudioCapturerDelegate>

@property (nonatomic, assign) NChart3DTypes seriesType;
@property (nonatomic, assign) NChart3DFunctionType functionType;
@property (nonatomic, assign) NChart3DColorScheme colorScheme;
@property (nonatomic, assign) int yearsCount;
@property (nonatomic, assign) int seriesCount;
@property (nonatomic, assign) int spectrum2DCount;
@property (nonatomic, assign) int sliceCount;
@property (nonatomic, assign) int spectrum3DCount;
@property (nonatomic, assign) BOOL smoothColumn;
@property (nonatomic, assign) BOOL drawIn3D;
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, assign) BOOL showLabels;
@property (nonatomic, assign) BOOL showMarkers;
@property (nonatomic, assign) BOOL showLegend;
@property (nonatomic, assign) int prevTimeIndex;
@property (nonatomic, strong) NSArray *arrayOfYears;
@property (nonatomic, strong) NSArray *arrayOfSeriesNames;
@property (nonatomic, strong) NSArray *brushes;
@property (nonatomic, strong) NSArray *gradientBrushes;
@property (nonatomic, strong) NSArray *contrastGradientBrushes;
@property (nonatomic, weak) id<NChart3DMainViewControllerDelegate> delegate;
@property (nonatomic, readonly) int spectrumStep;

- (NSInteger) parseYears;

@end
