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
 


typedef enum
{
    NChart3DTypesColumn,
    NChart3DTypesBar,
    NChart3DTypesArea,
    NChart3DTypesLine,
    NChart3DTypesStep,
    NChart3DTypesRibbon,
    NChart3DTypesPie,
    NChart3DTypesDoughnut,
    NChart3DTypesBubble,
    NChart3DTypesScatter,
    NChart3DTypesSurface,
    NChart3DTypesCandlestick,
    NChart3DTypesOHLC,
    NChart3DTypesBand,
    NChart3DTypesSequence,
    
    NChart3DTypesPieRotation,
    NChart3DTypesMultichart,
    
    NChart3DTypesStreamingColumn,
    NChart3DTypesStreamingArea,
    NChart3DTypesStreamingLine,
    NChart3DTypesStreamingStep,
    NChart3DTypesStreamingSurface
} NChart3DTypes;

typedef enum
{
    NChart3DTypeSeriesType,
    
    NChart3DDataDimension,
    NChart3DDataAxesType,
    NChart3DDataSeriesCount,
    NChart3DDataYearsCount,
    NChart3DDataFunctionType,
    NChart3DDataSpectrum2DCount,
    NChart3DDataSpectrum3DCount,
    
    NChart3DLayoutSlice,
    NChart3DLayoutSmooth,
    NChart3DLayoutShowBorder,
    NChart3DLayoutShowLabels,
    NChart3DLayoutShowMarkers,
    NChart3DLayoutLegend,
    NChart3DLayoutCaption,
    NChart3DLayoutXAxis,
    NChart3DLayoutYAxis,
    NChart3DLayoutZAxis,
    NChart3DLayoutColorScheme
} NChart3DProperties;

typedef enum
{
    NChart3DColorSchemeLight,
    NChart3DColorSchemeDark,
    NChart3DColorSchemeSimple,
    NChart3DColorSchemeTextured
} NChart3DColorScheme;

typedef enum
{
    NChart3DFunctionType1,
    NChart3DFunctionType2,
    NChart3DFunctionType3,
    NChart3DFunctionType4,
    NChart3DFunctionType5,
    NChart3DFunctionType6,
    NChart3DFunctionType7
} NChart3DFunctionType;

typedef enum
{
    NChart3DSettingsCharts,
    NChart3DSettingsChartSettings,
    NChart3DSettingsEffectSettings,
    NChart3DSettingsStreamingSettings,
    NChart3DSettingsLayout
} NChart3DSettings;

typedef enum
{
    NChart3DDimensions2D = 0,
    NChart3DDimensions3D = 1,
} NChart3DDimensions;

extern BOOL isIPhone();
extern BOOL isGEToIOSVersion(int version);
