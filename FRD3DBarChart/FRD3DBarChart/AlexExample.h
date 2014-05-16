//
//  AlexExample.h
//  FRD3DBarChart
//
//  Created by Al Pascual on 5/16/14.
//
//

#import <Foundation/Foundation.h>

#import "FRD3DBarChartViewController.h"
#import "CHCSVParser.h"

@interface AlexExample : NSObject<FRD3DBarChartViewControllerDelegate>
@property (nonatomic,strong) NSArray *fields;
@property (nonatomic,strong) NSArray *years;
@property (nonatomic,strong) NSArray *series;


- (void) generateArray;
- (NSInteger) parseYears;
- (NSArray*) extractedSeries:(NSArray*)myCSV;
- (NSArray*) getItemsInSeries:(NSString*)series;
@end
