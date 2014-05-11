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
 

#import "NChart3DAxesDataSource.h"
#import "NChart3DMainViewController.h"


@implementation NChart3DAxesDataSource
{
    NChart3DMainViewController *m_mainViewController;
}

- (id)initWithMainViewController:(NChart3DMainViewController *)mainViewController
{
    self = [super init];
    if (self)
    {
        m_mainViewController = mainViewController;
    }
    return self;
}

- (BOOL)zAxisShouldBeShorter
{
    switch (m_mainViewController.seriesType)
    {
        case NChart3DTypesArea:
        case NChart3DTypesLine:
        case NChart3DTypesStep:
        case NChart3DTypesRibbon:
            if (((NChartView *)m_mainViewController.view).chart.cartesianSystem.valueAxesType != NChartValueAxesTypeAbsolute)
                return YES;
            else
                return NO;
            
        default:
            return NO;
    }
}

#pragma mark - NChartSizeAxisDataSource


// Size AL:
- (float)sizeAxisDataSourceMinSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    float size;
    switch (m_mainViewController.seriesType)
    {
        case NChart3DTypesScatter:
            size = 15.0f;
            break;
            
        default:
            size = 10.0f;
            break;
    }
    if (isIPhone())
        size *= 0.6f;
    return size;
}

- (float)sizeAxisDataSourceMaxSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    float size;
    switch (m_mainViewController.seriesType)
    {
        case NChart3DTypesScatter:
            size = 15.0f;
            break;
            
        default:
            size = 50.0f;
            break;
    }
    if (isIPhone())
        size *= 0.6f;
    return size;
}

#pragma mark - NChartTimeAxisDataSource

- (NSArray *)timeAxisDataSourceTimestampsForAxis:(NChartTimeAxis *)timeAxis
{
    switch (m_mainViewController.seriesType)
    {
        case NChart3DTypesBubble:
        case NChart3DTypesScatter:
            return m_mainViewController.arrayOfYears;
            
        default:
            return nil;
    }
}

#pragma mark - NChartValueAxisDataSource

//- (NSString *)valueAxisDataSourceNameForAxis:(NChartValueAxis *)axis
//{
//    switch (m_mainViewController.seriesType)
//    {
//        case NChart3DTypesStreamingArea:
//        case NChart3DTypesStreamingColumn:
//        case NChart3DTypesStreamingLine:
//        case NChart3DTypesStreamingStep:
//        case NChart3DTypesStreamingSurface:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                    return NSLocalizedString(@"Hz", nil);
//                    
//                case NChartValueAxisY:
//                    return NSLocalizedString(@"Amount", nil);
//                    
//                case NChartValueAxisZ:
//                    return NSLocalizedString(@"Time", nil);
//                    
//                default:
//                    return nil;
//            }
//            break;
//            
//        default:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                    return NSLocalizedString(@"X-Axis", nil);
//                    
//                case NChartValueAxisY:
//                    return NSLocalizedString(@"Y-Axis", nil);
//                    
//                case NChartValueAxisZ:
//                    return NSLocalizedString(@"Z-Axis", nil);
//                    
//                default:
//                    return nil;
//            }
//    }
//}

//- (NSNumber *)valueAxisDataSourceStepForValueAxis:(NChartValueAxis *)axis
//{
//    switch (m_mainViewController.seriesType)
//    {
//        case NChart3DTypesScatter:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                case NChartValueAxisY:
//                    return @0.48;
//                    
//                default:
//                    return nil;
//            }
//            break;
//            
//        case NChart3DTypesStreamingArea:
//        case NChart3DTypesStreamingColumn:
//        case NChart3DTypesStreamingLine:
//        case NChart3DTypesStreamingStep:
//        case NChart3DTypesStreamingSurface:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                    return [NSNumber numberWithInt:m_mainViewController.spectrumStep];
//                    
//                case NChartValueAxisY:
//                    return @0.05;
//                    
//                default:
//                    return nil;
//            }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return nil;
//}
//
//- (NSNumber *)valueAxisDataSourceMaxForValueAxis:(NChartValueAxis *)axis
//{
//    switch (m_mainViewController.seriesType)
//    {
//        case NChart3DTypesScatter:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                case NChartValueAxisY:
//                    return @1.2;
//                    
//                default:
//                    return nil;
//            }
//            break;
//            
//        case NChart3DTypesSurface:
//            if (axis.kind == NChartValueAxisY)
//                return @1.0;
//            break;
//            
//        case NChart3DTypesStreamingColumn:
//        case NChart3DTypesStreamingArea:
//        case NChart3DTypesStreamingLine:
//        case NChart3DTypesStreamingStep:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                    return [NSNumber numberWithInt:(m_mainViewController.drawIn3D ?
//                                                    m_mainViewController.spectrum3DCount :
//                                                    m_mainViewController.spectrum2DCount) * m_mainViewController.spectrumStep];
//                    
//                case NChartValueAxisY:
//                    return @0.3;
//                    
//                case NChartValueAxisZ:
//                    return [NSNumber numberWithInt:m_mainViewController.spectrum3DCount];
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        case NChart3DTypesStreamingSurface:
//            switch (axis.kind)
//            {
//                case NChartValueAxisX:
//                    return [NSNumber numberWithInt:m_mainViewController.spectrum3DCount * m_mainViewController.spectrumStep];
//                    
//                case NChartValueAxisY:
//                    return @0.3;
//                    
//                case NChartValueAxisZ:
//                    return [NSNumber numberWithInt:m_mainViewController.spectrum3DCount];
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return nil;
//}
//
//- (NSNumber *)valueAxisDataSourceMinForValueAxis:(NChartValueAxis *)axis
//{
//    switch (m_mainViewController.seriesType)
//    {
//        case NChart3DTypesScatter:
//            switch (axis.kind)
//        {
//            case NChartValueAxisX:
//            case NChartValueAxisY:
//                return @-1.2;
//                
//            default:
//                break;
//        }
//            break;
//            
//        case NChart3DTypesSurface:
//            if (axis.kind == NChartValueAxisY)
//                return @-1.0;
//            break;
//            
//        case NChart3DTypesStreamingArea:
//        case NChart3DTypesStreamingLine:
//        case NChart3DTypesStreamingStep:
//        case NChart3DTypesStreamingSurface:
//            if (axis.kind == NChartValueAxisY)
//                return @0.0;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return nil;
//}

//- (NSArray *)valueAxisDataSourceTicksForValueAxis:(NChartValueAxis *)axis
//{
//    switch (axis.kind)
//    {
//        case NChartValueAxisX:
//        {
//            switch (m_mainViewController.seriesType)
//            {
//                case NChart3DTypesColumn:
//                case NChart3DTypesArea:
//                case NChart3DTypesLine:
//                case NChart3DTypesStep:
//                case NChart3DTypesRibbon:
//                case NChart3DTypesCandlestick:
//                case NChart3DTypesOHLC:
//                case NChart3DTypesMultichart:
//                    return m_mainViewController.arrayOfYears;
//                    
//                default:
//                    return nil;
//            }
//        }
//            
//        case NChartValueAxisY:
//        {
//            switch (m_mainViewController.seriesType)
//            {
//                case NChart3DTypesBar:
//                    return m_mainViewController.arrayOfYears;
//                    
//                case NChart3DTypesSequence:
//                    return @[NSLocalizedString(@"Alpha", nil), NSLocalizedString(@"Beta", nil),
//                             NSLocalizedString(@"Gamma", nil), NSLocalizedString(@"Delta", nil)];
//                    
//                default:
//                    return nil;
//            }
//        }
//            
//        case NChartValueAxisZ:
//            switch (m_mainViewController.seriesType)
//        {
//            case NChart3DTypesColumn:
//            case NChart3DTypesBar:
//                return @[NSLocalizedString(@"Alpha", nil), NSLocalizedString(@"Beta", nil),
//                         NSLocalizedString(@"Gamma", nil), NSLocalizedString(@"Delta", nil)];
//                
//            case NChart3DTypesArea:
//            case NChart3DTypesLine:
//            case NChart3DTypesStep:
//            case NChart3DTypesRibbon:
//            case NChart3DTypesCandlestick:
//            case NChart3DTypesOHLC:
//                return (((NChartView *)m_mainViewController.view).chart.cartesianSystem.valueAxesType == NChartValueAxesTypeAbsolute ?
//                        m_mainViewController.arrayOfSeriesNames : @[NSLocalizedString(@"All series", nil)]);
//                
//            case NChart3DTypesMultichart:
//                return @[NSLocalizedString(@"Area", nil), NSLocalizedString(@"Column", nil),
//                         NSLocalizedString(@"Line", nil)];
//                
//            default:
//                return nil;
//        }
//            
//        default:
//            return nil;
//    }
//}

//- (NSNumber *)valueAxisDataSourceLengthForValueAxis:(NChartValueAxis *)axis
//{
//    return (axis.kind == NChartValueAxisZ && [self zAxisShouldBeShorter]) ? @0.3f : nil;
//}

//- (NSString *)valueAxisDataSourceDouble:(double)value toStringForValueAxis:(NChartValueAxis *)axis
//{
//    switch (axis.kind)
//    {
//        case NChartValueAxisX:
//            switch (m_mainViewController.seriesType)
//            {
//                case NChart3DTypesStreamingColumn:
//                case NChart3DTypesStreamingArea:
//                case NChart3DTypesStreamingLine:
//                case NChart3DTypesStreamingStep:
//                case NChart3DTypesStreamingSurface:
//                    return [NSString stringWithFormat:@"%d", (int)value];
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        default:
//            break;
//    }
//
//    return [NSString stringWithFormat:@"%.2f", value];
//}

@end
