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
 

#import "NChart3DSettingsViewController.h"
#ifdef NCHART3D_SOURCES
#import "NChart3D.h"
#else
#import <NChart3D/NChart3D.h>
#endif // NCHART3D_SOURCES


#define typeCell(typeID)                                                                            \
    [NChart3DTableViewCell cellWithText:[self seriesNameForSeriesType:typeID]                       \
                                  image:[UIImage imageNamed:[self seriesImageForSeriesType:typeID]] \
                                 target:self                                                        \
                                 action:@selector(checkElem:)                                       \
                                    tag:NChart3DTypeSeriesType                                      \
                                  value:typeID]

#define checkCell(checkName, checkID, checkValue) \
    [NChart3DTableViewCell cellWithText:checkName target:self action:@selector(checkElem:) tag:checkID value:checkValue]

#define switchCell(switchName, switchID) \
    [NChart3DSwitchTableViewCell cellWithText:switchName switchTag:switchID switchTarget:self switchSelector:@selector(switchElem:)]

#define sliderCell(sliderMin, sliderMax, sliderID) \
    [NChart3DSliderTableViewCell cellWithMin:sliderMin max:sliderMax target:self action:@selector(slideElem:) tag:sliderID]

#define disclosureCell(disID) \
    [NChart3DDisclosureTableViewCell cellWithDisclosureID:disID target:self action:@selector(pushElem:) tag:NChart3DTypeSeriesType]

#define MAX_YEARS_COUNT 20
#define MAX_SERIES_COUNT 25

@interface NChart3DSettingsViewController ()

@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) NSArray *captions;

@end

@implementation NChart3DSettingsViewController
{
    NChart3DSettings m_settingsType;
    NChart3DSettings m_prevSettingsType;
}

- (id)initWithSettingsID:(NChart3DSettings)settingsID
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        m_settingsType = settingsID;
        m_prevSettingsType = settingsID;
        self.title = [self titleForSettingsID:settingsID];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateSettings:)
                                                     name:@"NChart3DUpdateSettings"
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.settingTypes)
    {
        NSMutableArray *settingsCaptions = [NSMutableArray array];
        for (NSNumber *type in self.settingTypes)
            [settingsCaptions addObject:[self titleForSettingsID:(NChart3DSettings)(type.intValue)]];
        UISegmentedControl *settings = [[UISegmentedControl alloc] initWithItems:settingsCaptions];
        [settings addTarget:self action:@selector(changeSettings:) forControlEvents:UIControlEventValueChanged];
        settings.segmentedControlStyle = UISegmentedControlStyleBar;
        settings.selectedSegmentIndex = 0;
        self.navigationItem.titleView = settings;
    }
    
    [self updateSettingsList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isIPhone())
        [NSNotificationCenter.defaultCenter postNotificationName:@"NChart3DUpdateSettings" object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ((NSArray *)[self.settings objectAtIndex:m_settingsType]).count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[((NSArray *)[self.settings objectAtIndex:m_settingsType]) objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UITableViewCell *)[((NSArray *)[((NSArray *)[self.settings objectAtIndex:m_settingsType])
                                            objectAtIndex:indexPath.section])
                               objectAtIndex:indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = ((NSArray *)[self.captions objectAtIndex:m_settingsType]);
    return section < array.count ? array[section] : nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [((NChart3DTableViewCell *)[((NSArray *)[((NSArray *)[self.settings objectAtIndex:m_settingsType])
                                             objectAtIndex:indexPath.section])
                                objectAtIndex:indexPath.row]) performAction];
}

#pragma mark - Helpers

- (NSString *)seriesNameForSeriesType:(NChart3DTypes)type
{
    switch (type)
    {
        case NChart3DTypesColumn:
            return NSLocalizedString(@"Column", nil);
            
        case NChart3DTypesBar:
            return NSLocalizedString(@"Bar", nil);
            
        case NChart3DTypesArea:
            return NSLocalizedString(@"Area", nil);
            
        case NChart3DTypesLine:
            return NSLocalizedString(@"Line", nil);
            
        case NChart3DTypesStep:
            return NSLocalizedString(@"Step line", nil);
            
        case NChart3DTypesRibbon:
            return NSLocalizedString(@"Ribbon", nil);
            
        case NChart3DTypesPie:
            return NSLocalizedString(@"Pie", nil);
            
        case NChart3DTypesDoughnut:
            return NSLocalizedString(@"Doughnut", nil);
            
        case NChart3DTypesBubble:
            return NSLocalizedString(@"Bubble", nil);
            
        case NChart3DTypesScatter:
            return NSLocalizedString(@"Scatter", nil);
            
        case NChart3DTypesSurface:
            return NSLocalizedString(@"Surface", nil);
            
        case NChart3DTypesCandlestick:
            return NSLocalizedString(@"Candlestick", nil);
            
        case NChart3DTypesOHLC:
            return NSLocalizedString(@"OHLC", nil);
            
        case NChart3DTypesBand:
            return NSLocalizedString(@"Band", nil);
            
        case NChart3DTypesSequence:
            return NSLocalizedString(@"Sequence", nil);
            
        case NChart3DTypesPieRotation:
            return NSLocalizedString(@"Pie rotation", nil);
            
        case NChart3DTypesMultichart:
            return NSLocalizedString(@"Multichart", nil);
            
        case NChart3DTypesStreamingColumn:
            return NSLocalizedString(@"Column", nil);
            
        case NChart3DTypesStreamingArea:
            return NSLocalizedString(@"Area", nil);
            
        case NChart3DTypesStreamingLine:
            return NSLocalizedString(@"Line", nil);
            
        case NChart3DTypesStreamingStep:
            return NSLocalizedString(@"Step line", nil);
            
        case NChart3DTypesStreamingSurface:
            return NSLocalizedString(@"Surface", nil);
            
        default:
            return nil;
    }
}

- (NSString *)seriesImageForSeriesType:(NChart3DTypes)type
{
    switch (type)
    {
        case NChart3DTypesColumn:
            return @"column.png";
            
        case NChart3DTypesBar:
            return @"bar.png";
            
        case NChart3DTypesArea:
            return @"area.png";
            
        case NChart3DTypesLine:
            return @"line.png";
            
        case NChart3DTypesStep:
            return @"step.png";
            
        case NChart3DTypesRibbon:
            return @"ribbon.png";
            
        case NChart3DTypesPie:
            return @"pie.png";
            
        case NChart3DTypesDoughnut:
            return @"doughnut.png";
            
        case NChart3DTypesBubble:
            return @"bubble.png";
            
        case NChart3DTypesScatter:
            return @"scatter.png";
            
        case NChart3DTypesSurface:
            return @"surface.png";
            
        case NChart3DTypesCandlestick:
            return @"candlestick.png";
            
        case NChart3DTypesOHLC:
            return @"ohlc.png";
            
        case NChart3DTypesBand:
            return @"band.png";
            
        case NChart3DTypesSequence:
            return @"sequence.png";
            
        case NChart3DTypesPieRotation:
            return @"pie.png";
            
        case NChart3DTypesMultichart:
            return @"multi.png";
            
        case NChart3DTypesStreamingColumn:
            return @"column.png";
            
        case NChart3DTypesStreamingArea:
            return @"area.png";
            
        case NChart3DTypesStreamingLine:
            return @"line.png";
            
        case NChart3DTypesStreamingStep:
            return @"step.png";
            
        case NChart3DTypesStreamingSurface:
            return @"surface.png";
            
        default:
            return nil;
    }
}

- (NSString *)titleForSettingsID:(NChart3DSettings)settingsID
{
    switch (settingsID)
    {
        case NChart3DSettingsCharts:
            return NSLocalizedString(@"Chart type", nil);
            
        case NChart3DSettingsChartSettings:
            return NSLocalizedString(@"Charts", nil);
            
        case NChart3DSettingsEffectSettings:
            return NSLocalizedString(@"Effects", nil);
            
        case NChart3DSettingsStreamingSettings:
            return NSLocalizedString(@"Streaming", nil);
            
        case NChart3DSettingsLayout:
            return NSLocalizedString(@"Layout", nil);
            
        default:
            return nil;
    }
}

#pragma mark - Settings changing

- (void)addChartsElemsTo:(NSMutableArray *)arrayOfSettings andCaptionsTo:(NSMutableArray *)arrayOfCaptions
{
    [arrayOfCaptions addObject:@[]];
    
    [arrayOfSettings addObject:@[@[
                                     typeCell(NChart3DTypesColumn),
                                     typeCell(NChart3DTypesBar),
                                     typeCell(NChart3DTypesArea),
                                     typeCell(NChart3DTypesLine),
                                     typeCell(NChart3DTypesStep),
                                     typeCell(NChart3DTypesRibbon),
                                     typeCell(NChart3DTypesPie),
                                     typeCell(NChart3DTypesDoughnut),
                                     typeCell(NChart3DTypesBubble),
                                     typeCell(NChart3DTypesScatter),
                                     typeCell(NChart3DTypesSurface),
                                     typeCell(NChart3DTypesCandlestick),
                                     typeCell(NChart3DTypesOHLC),
                                     typeCell(NChart3DTypesBand),
                                     typeCell(NChart3DTypesSequence)
                                ]]];
}

- (void)addChartSettingsElemsTo:(NSMutableArray *)arrayOfSettings andCaptionsTo:(NSMutableArray *)arrayOfCaptions
{
    switch (((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DTypeSeriesType]).intValue)
    {
        case NChart3DTypesColumn:
        case NChart3DTypesBar:
        case NChart3DTypesArea:
        case NChart3DTypesLine:
        case NChart3DTypesStep:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Dimensions", nil),
                                         NSLocalizedString(@"Value axis type", nil),
                                         NSLocalizedString(@"Number of series", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             disclosureCell(NChart3DSettingsCharts)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"2D", nil), NChart3DDataDimension,
                                                       NChart3DDimensions2D),
                                             checkCell(NSLocalizedString(@"3D", nil), NChart3DDataDimension,
                                                       NChart3DDimensions3D)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Absolute", nil), NChart3DDataAxesType,
                                                       NChartValueAxesTypeAbsolute),
                                             checkCell(NSLocalizedString(@"Additive", nil), NChart3DDataAxesType,
                                                       NChartValueAxesTypeAdditive),
                                             checkCell(NSLocalizedString(@"Percent", nil), NChart3DDataAxesType,
                                                       NChartValueAxesTypePercent)
                                          ],
                                         @[
                                             sliderCell(1, MAX_SERIES_COUNT, NChart3DDataSeriesCount)
                                          ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                          ]
                                        ]];
            break;
            
        case NChart3DTypesRibbon:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Value axis type", nil),
                                         NSLocalizedString(@"Number of series", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             disclosureCell(NChart3DSettingsCharts)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Absolute", nil), NChart3DDataAxesType,
                                                       NChartValueAxesTypeAbsolute),
                                             checkCell(NSLocalizedString(@"Additive", nil), NChart3DDataAxesType,
                                                       NChartValueAxesTypeAdditive),
                                             checkCell(NSLocalizedString(@"Percent", nil), NChart3DDataAxesType,
                                                       NChartValueAxesTypePercent)
                                          ],
                                         @[
                                             sliderCell(1, MAX_SERIES_COUNT, NChart3DDataSeriesCount)
                                          ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesSurface:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Function type", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             disclosureCell(NChart3DSettingsCharts)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"y = sin(a·x)·cos(b·z)", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType1),
                                             checkCell(NSLocalizedString(@"y = a·atan(b·x·z)", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType2),
                                             checkCell(NSLocalizedString(@"y = a·(x²+z²)", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType3),
                                             checkCell(NSLocalizedString(@"y = sin(a·x)·cos(b·z)", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType4),
                                             checkCell(NSLocalizedString(@"y = a·cos(b·(x²+z²))·exp(c·(x²+z²))", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType5),
                                             checkCell(NSLocalizedString(@"y = a·sin(b·x)+c·z", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType6),
                                             checkCell(NSLocalizedString(@"y = a·(1-x·z)·sin(1-x·z)", nil), NChart3DDataFunctionType,
                                                       NChart3DFunctionType7),
                                          ],
                                        ]];
            break;
            
        case NChart3DTypesPie:
        case NChart3DTypesDoughnut:
        case NChart3DTypesBubble:
        case NChart3DTypesScatter:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Dimensions", nil),
                                         NSLocalizedString(@"Number of series", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             disclosureCell(NChart3DSettingsCharts)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"2D", nil), NChart3DDataDimension,
                                                       NChart3DDimensions2D),
                                             checkCell(NSLocalizedString(@"3D", nil), NChart3DDataDimension,
                                                       NChart3DDimensions3D)
                                          ],
                                         @[
                                             sliderCell(1, MAX_SERIES_COUNT, NChart3DDataSeriesCount)
                                          ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                          ]
                                        ]];
            break;
            
        case NChart3DTypesBand:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             disclosureCell(NChart3DSettingsCharts)
                                          ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesSequence:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Number of series", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             disclosureCell(NChart3DSettingsCharts)
                                             ],
                                         @[
                                             sliderCell(1, MAX_SERIES_COUNT, NChart3DDataSeriesCount)
                                             ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                             ]
                                         ]];
            break;
            
        case NChart3DTypesCandlestick:
        case NChart3DTypesOHLC:
            if (((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DDataDimension]).intValue == NChart3DDimensions2D)
            {
                [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                             NSLocalizedString(@"Dimensions", nil),
                                             NSLocalizedString(@"Number of years", nil)]];
                [arrayOfSettings addObject:@[
                                             @[
                                                 disclosureCell(NChart3DSettingsCharts)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"2D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions2D),
                                                 checkCell(NSLocalizedString(@"3D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions3D)
                                              ],
                                             @[
                                                 sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                             NSLocalizedString(@"Dimensions", nil),
                                             NSLocalizedString(@"Number of series", nil),
                                             NSLocalizedString(@"Number of years", nil)]];
                [arrayOfSettings addObject:@[
                                             @[
                                                 disclosureCell(NChart3DSettingsCharts)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"2D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions2D),
                                                 checkCell(NSLocalizedString(@"3D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions3D)
                                              ],
                                             @[
                                                 sliderCell(1, MAX_SERIES_COUNT, NChart3DDataSeriesCount)
                                              ],
                                             @[
                                                 sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                              ]
                                             ]];
            }
            break;
            
        default:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil)]];
            [arrayOfSettings addObject:@[@[disclosureCell(NChart3DSettingsCharts)]]];
            break;
    }
}

- (void)addEffectSettingsElemsTo:(NSMutableArray *)arrayOfSettings andCaptionsTo:(NSMutableArray *)arrayOfCaptions
{
    switch (((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DTypeSeriesType]).intValue)
    {
        case NChart3DTypesMultichart:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart effect", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             typeCell(NChart3DTypesPieRotation),
                                             typeCell(NChart3DTypesMultichart)
                                          ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesPieRotation:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart effect", nil),
                                         NSLocalizedString(@"Number of series", nil),
                                         NSLocalizedString(@"Number of years", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             typeCell(NChart3DTypesPieRotation),
                                             typeCell(NChart3DTypesMultichart)
                                          ],
                                         @[
                                             sliderCell(1, MAX_SERIES_COUNT, NChart3DDataSeriesCount)
                                          ],
                                         @[
                                             sliderCell(1, MAX_YEARS_COUNT, NChart3DDataYearsCount)
                                          ]
                                         ]];
            break;
            
        default:
            [arrayOfCaptions addObject:@[]];
            [arrayOfSettings addObject:@[]];
            break;
    }
}

- (void)addStreamingSettingsElemsTo:(NSMutableArray *)arrayOfSettings andCaptionsTo:(NSMutableArray *)arrayOfCaptions
{
    switch (((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DTypeSeriesType]).intValue)
    {
        case NChart3DTypesStreamingColumn:
        case NChart3DTypesStreamingArea:
        case NChart3DTypesStreamingLine:
        case NChart3DTypesStreamingStep:
            if (((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DDataDimension]).intValue == NChart3DDimensions2D)
            {
                [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                             NSLocalizedString(@"Dimensions", nil),
                                             NSLocalizedString(@"Resolution", nil)]];
                [arrayOfSettings addObject:@[
                                             @[
                                                 typeCell(NChart3DTypesStreamingColumn),
                                                 typeCell(NChart3DTypesStreamingArea),
                                                 typeCell(NChart3DTypesStreamingLine),
                                                 typeCell(NChart3DTypesStreamingStep),
                                                 typeCell(NChart3DTypesStreamingSurface),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"2D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions2D),
                                                 checkCell(NSLocalizedString(@"3D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions3D)
                                              ],
                                             @[
                                                 sliderCell(32, 128, NChart3DDataSpectrum2DCount)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                             NSLocalizedString(@"Dimensions", nil),
                                             NSLocalizedString(@"Resolution", nil)]];
                [arrayOfSettings addObject:@[
                                             @[
                                                 typeCell(NChart3DTypesStreamingColumn),
                                                 typeCell(NChart3DTypesStreamingArea),
                                                 typeCell(NChart3DTypesStreamingLine),
                                                 typeCell(NChart3DTypesStreamingStep),
                                                 typeCell(NChart3DTypesStreamingSurface),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"2D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions2D),
                                                 checkCell(NSLocalizedString(@"3D", nil), NChart3DDataDimension,
                                                           NChart3DDimensions3D)
                                              ],
                                             @[
                                                 sliderCell(30, 60, NChart3DDataSpectrum3DCount)
                                              ]
                                             ]];
            }
            break;
            
        case NChart3DTypesStreamingSurface:
            [arrayOfCaptions addObject:@[NSLocalizedString(@"Chart type", nil),
                                         NSLocalizedString(@"Resolution", nil)]];
            [arrayOfSettings addObject:@[
                                         @[
                                             typeCell(NChart3DTypesStreamingColumn),
                                             typeCell(NChart3DTypesStreamingArea),
                                             typeCell(NChart3DTypesStreamingLine),
                                             typeCell(NChart3DTypesStreamingStep),
                                             typeCell(NChart3DTypesStreamingSurface),
                                          ],
                                         @[
                                             sliderCell(30, 60, NChart3DDataSpectrum3DCount)
                                          ]
                                         ]];
            break;
            
        default:
            [arrayOfCaptions addObject:@[]];
            [arrayOfSettings addObject:@[]];
            break;
    }
}

- (void)addLayoutElemsTo:(NSMutableArray *)arrayOfSettings andCaptionsTo:(NSMutableArray *)arrayOfCaptions
{
    int dimension = ((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DDataDimension]).intValue;
    int seriesType = ((NSNumber *)[self.settingsDelegate settingsValueForProp:NChart3DTypeSeriesType]).intValue;
    if ((seriesType == NChart3DTypesColumn || seriesType == NChart3DTypesBar) && dimension == NChart3DDimensions3D)
        [arrayOfCaptions addObject:@[NSLocalizedString(@"Slice", nil), NSLocalizedString(@"Elements", nil), NSLocalizedString(@"Color scheme", nil)]];
    else
        [arrayOfCaptions addObject:@[NSLocalizedString(@"Elements", nil), NSLocalizedString(@"Color scheme", nil)]];
    
    switch (seriesType)
    {
        case NChart3DTypesColumn:
        case NChart3DTypesBar:
            if (dimension == NChart3DDimensions2D)
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                            ]];
            }
            else
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 sliderCell(3, 32, NChart3DLayoutSlice)
                                              ],
                                             @[
                                                 switchCell(NSLocalizedString(@"Smooth", nil), NChart3DLayoutSmooth),
                                                 switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                                 switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            break;
            
            
        case NChart3DTypesBubble:
        case NChart3DTypesScatter:
            if (dimension == NChart3DDimensions2D)
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                                 switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            break;
            
        case NChart3DTypesStreamingArea:
        case NChart3DTypesStreamingColumn:
        case NChart3DTypesStreamingLine:
        case NChart3DTypesStreamingStep:
        case NChart3DTypesStreamingSurface:
            if (dimension == NChart3DDimensions2D)
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                                 switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            break;
            
        case NChart3DTypesArea:
            if (dimension == NChart3DDimensions2D)
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Show markers", nil), NChart3DLayoutShowMarkers),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Show markers", nil), NChart3DLayoutShowMarkers),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                                 switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            break;
            
        case NChart3DTypesSurface:
            [arrayOfSettings addObject:@[
                                         @[
                                             switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                             switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                             switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                             switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                             switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                             switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeLight),
                                             checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeDark),
                                             checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeSimple),
                                             checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeTextured)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesRibbon:
            [arrayOfSettings addObject:@[
                                         @[
                                             switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                             switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                             switchCell(NSLocalizedString(@"Show markers", nil), NChart3DLayoutShowMarkers),
                                             switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                             switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                             switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                             switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                             switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeLight),
                                             checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeDark),
                                             checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeSimple),
                                             checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeTextured)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesCandlestick:
        case NChart3DTypesOHLC:
            if (dimension == NChart3DDimensions2D)
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Disable tooltips", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Disable tooltips", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                                 switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            break;
            
        case NChart3DTypesBand:
        case NChart3DTypesSequence:
            [arrayOfSettings addObject:@[
                                         @[
                                             switchCell(NSLocalizedString(@"Disable tooltips", nil), NChart3DLayoutShowLabels),
                                             switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                             switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                             switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                             switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeLight),
                                             checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeDark),
                                             checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeSimple),
                                             checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeTextured)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesLine:
        case NChart3DTypesStep:
            if (dimension == NChart3DDimensions2D)
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Show markers", nil), NChart3DLayoutShowMarkers),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            else
            {
                [arrayOfSettings addObject:@[
                                             @[
                                                 switchCell(NSLocalizedString(@"Show labels", nil), NChart3DLayoutShowLabels),
                                                 switchCell(NSLocalizedString(@"Show markers", nil), NChart3DLayoutShowMarkers),
                                                 switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                                 switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                                 switchCell(NSLocalizedString(@"X-Axis", nil), NChart3DLayoutXAxis),
                                                 switchCell(NSLocalizedString(@"Y-Axis", nil), NChart3DLayoutYAxis),
                                                 switchCell(NSLocalizedString(@"Z-Axis", nil), NChart3DLayoutZAxis)
                                              ],
                                             @[
                                                 checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeLight),
                                                 checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeDark),
                                                 checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeSimple),
                                                 checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                           NChart3DColorSchemeTextured)
                                              ]
                                             ]];
            }
            break;
            
        case NChart3DTypesPie:
        case NChart3DTypesDoughnut:
            [arrayOfSettings addObject:@[
                                         @[
                                             switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                             switchCell(NSLocalizedString(@"Disable tooltips", nil), NChart3DLayoutShowLabels),
                                             switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                             switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeLight),
                                             checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeDark),
                                             checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeSimple),
                                             checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeTextured)
                                          ]
                                        ]];
            break;
            
        case NChart3DTypesPieRotation:
            [arrayOfSettings addObject:@[
                                         @[
                                             switchCell(NSLocalizedString(@"Show border", nil), NChart3DLayoutShowBorder),
                                             switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                             switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeLight),
                                             checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeDark),
                                             checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeSimple),
                                             checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeTextured)
                                          ]
                                         ]];
            break;
            
        case NChart3DTypesMultichart:
            [arrayOfSettings addObject:@[
                                         @[
                                             switchCell(NSLocalizedString(@"Legend", nil), NChart3DLayoutLegend),
                                             switchCell(NSLocalizedString(@"Caption", nil), NChart3DLayoutCaption),
                                          ],
                                         @[
                                             checkCell(NSLocalizedString(@"Light colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeLight),
                                             checkCell(NSLocalizedString(@"Dark colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeDark),
                                             checkCell(NSLocalizedString(@"Simple colors", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeSimple),
                                             checkCell(NSLocalizedString(@"Image", nil), NChart3DLayoutColorScheme,
                                                       NChart3DColorSchemeTextured)
                                          ]
                                         ]];
            break;
            
        default:
            [arrayOfSettings addObject:@[]];
            break;
    }
}

- (void)updateSettingsList
{
    NSMutableArray *arrayOfSettings = [NSMutableArray array];
    NSMutableArray *arrayOfCaptions = [NSMutableArray array];
    
    [self addChartsElemsTo:arrayOfSettings andCaptionsTo:arrayOfCaptions];
    [self addChartSettingsElemsTo:arrayOfSettings andCaptionsTo:arrayOfCaptions];
    [self addEffectSettingsElemsTo:arrayOfSettings andCaptionsTo:arrayOfCaptions];
    [self addStreamingSettingsElemsTo:arrayOfSettings andCaptionsTo:arrayOfCaptions];
    [self addLayoutElemsTo:arrayOfSettings andCaptionsTo:arrayOfCaptions];
    
    self.settings = arrayOfSettings;
    self.captions = arrayOfCaptions;
    
    for (NSArray *segmentArray in self.settings)
    {
        for (NSArray *sectionArray in segmentArray)
        {
            for (NChart3DTableViewCell *cell in sectionArray)
            {
                NSNumber *value = [self.settingsDelegate settingsValueForProp:cell.tag];
                if ([cell isMemberOfClass:[NChart3DSwitchTableViewCell class]])
                {
                    ((NChart3DSwitchTableViewCell *)cell).switchControl.on = value.boolValue;
                }
                else if ([cell isMemberOfClass:[NChart3DSliderTableViewCell class]])
                {
                    ((NChart3DSliderTableViewCell *)cell).currentValue = value.intValue;
                }
                else if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
                {
                    NChart3DTypes type = (NChart3DTypes)(value.intValue);
                    if (((NChart3DDisclosureTableViewCell *)cell).disclosureID == NChart3DSettingsCharts)
                    {
                        if (type < NChart3DTypesPieRotation)
                        {
                            cell.textLabel.text = [self seriesNameForSeriesType:type];
                            cell.imageView.image = [UIImage imageNamed:[self seriesImageForSeriesType:type]];
                        }
                        else
                        {
                            cell.textLabel.text = NSLocalizedString(@"Select chart type", nil);
                            cell.imageView.image = nil;
                        }
                    }
                    else
                    {
                        if (type >= NChart3DTypesPieRotation)
                        {
                            cell.textLabel.text = [self seriesNameForSeriesType:type];
                            cell.imageView.image = [UIImage imageNamed:[self seriesImageForSeriesType:type]];
                        }
                        else
                        {
                            cell.textLabel.text = NSLocalizedString(@"Select chart effect", nil);
                            cell.imageView.image = nil;
                        }
                    }
                    cell.value = value.intValue;
                }
                else
                {
                    cell.checked = value.intValue == cell.value;
                }
            }
        }
    }
}

- (void)updateSettings:(id)dummy
{
    [self updateSettingsList];
    [self.tableView reloadData];
}

- (void)changeSettings:(UISegmentedControl *)segmented
{
    segmented.userInteractionEnabled = NO;
    
    NChart3DSettings type = (NChart3DSettings)(((NSNumber *)self.settingTypes[segmented.selectedSegmentIndex]).intValue);
    
    if (type != NChart3DSettingsLayout)
        m_settingsType = type;
    
    if (m_prevSettingsType != m_settingsType)
    {
        switch (m_settingsType)
        {
            case NChart3DSettingsChartSettings:
                [self.settingsDelegate settingsSetValue:[NSNumber numberWithInt:NChart3DTypesColumn]
                                                forProp:NChart3DTypeSeriesType];
                break;
                
            case NChart3DSettingsEffectSettings:
                [self.settingsDelegate settingsSetValue:[NSNumber numberWithInt:NChart3DTypesPieRotation]
                                                forProp:NChart3DTypeSeriesType];
                break;
                
            case NChart3DSettingsStreamingSettings:
                [self.settingsDelegate settingsSetValue:[NSNumber numberWithInt:NChart3DTypesStreamingColumn]
                                                forProp:NChart3DTypeSeriesType];
                break;
                
            default:
                break;
        }
    }
    
    m_prevSettingsType = m_settingsType;
    m_settingsType = type;
    
    [self.tableView reloadData];
    
    segmented.userInteractionEnabled = YES;
}

- (void)checkElem:(NChart3DTableViewCell *)cell
{
    if (cell.checked)
    {
        cell.selected = NO;
        return;
    }
    
    NSArray *array = (NSArray *)[self.settings objectAtIndex:m_settingsType];
    NSInteger section = 0;
    for (NSInteger i = 0, n = array.count; i < n; ++i)
    {
        if (((NChart3DTableViewCell *)[[array objectAtIndex:i] lastObject]).tag == cell.tag)
        {
            section = i;
            break;
        }
    }
    array = (NSArray *)[array objectAtIndex:section];
    for (NChart3DTableViewCell *elem in array)
    {
        if (elem.checked)
            elem.checked = NO;
    }
    
    self.view.userInteractionEnabled = NO;
    self.navigationItem.titleView.userInteractionEnabled = NO;
    [cell showWaiter];
    [self.settingsDelegate settingsSetValue:[NSNumber numberWithInt:cell.value] forProp:cell.tag];
    [cell hideWaiter];
    cell.checked = YES;
    self.navigationItem.titleView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    if (self.shouldPopOnSelection)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchElem:(NChart3DSwitch *)switcher
{
    self.navigationItem.titleView.userInteractionEnabled = NO;
    [switcher.cell showWaiter];
    
    [self.settingsDelegate settingsSetValue:[NSNumber numberWithBool:switcher.on] forProp:switcher.tag];
    
    [switcher.cell hideWaiter];
    self.navigationItem.titleView.userInteractionEnabled = YES;
}

- (void)slideElem:(NChart3DSliderTableViewCell *)cell
{
    self.navigationItem.titleView.userInteractionEnabled = NO;
    [self.settingsDelegate settingsSetValue:[NSNumber numberWithInt:cell.currentValue] forProp:cell.tag];
    self.navigationItem.titleView.userInteractionEnabled = YES;
}

- (void)pushElem:(NChart3DDisclosureTableViewCell *)cell
{
    NChart3DSettingsViewController *ctrl = [[NChart3DSettingsViewController alloc]
                                             initWithSettingsID:(NChart3DSettings)(cell.disclosureID)];
    ctrl.settingsDelegate = self.settingsDelegate;
    ctrl.shouldPopOnSelection = YES;
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
