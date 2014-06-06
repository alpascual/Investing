//
//  AlexExample.m
//  FRD3DBarChart
//
//  Created by Al Pascual on 5/16/14.
//
//

#import "AlexExample.h"

@implementation AlexExample



// number of rows to display in the chart.
-(int) frd3DBarChartViewControllerNumberRows:(FRD3DBarChartViewController *) frd3DBarChardViewController
{
    if ( self.fields == nil)
        [self generateArray];
    
   self.series = [self extractedSeries:self.fields];
    
    return self.series.count;
}


// number of columns to display in the chart
-(int) frd3DBarChartViewControllerNumberColumns:(FRD3DBarChartViewController *) frd3DBarChardViewController
{
    if ( self.series == nil)
    {
        if ( self.fields == nil)
            [self generateArray];
        
        self.series = [self extractedSeries:self.fields];
    }
    
    NSArray *itemPerSeries = [self getItemsInSeries:[self.series objectAtIndex:0]];
    
    return itemPerSeries.count;
}


// maximum value (height of the bar). Heights are normalized using this value.
-(float) frd3DBarChartViewControllerMaxValue:(FRD3DBarChartViewController *) frd3DBarChardViewController
{
    float maxValue = 0;
    for (int i=0; i < self.fields.count; i++) {
        NSArray *item = [self.fields objectAtIndex:i];
        double x = [[item objectAtIndex:2] doubleValue];
        if ( x > maxValue)
            maxValue = x;
    }
    
    return maxValue;
}

// value (height) of a bar in the chart
-(float) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChardViewController valueForBarAtRow:(int)row column:(int)column
{
    //NSLog(@"Column %d row %d", column, row);
    NSArray *itemPerSeries = [self getItemsInSeries:[self.series objectAtIndex:row]];
    NSArray *item = [itemPerSeries objectAtIndex:column];
    
    float XValue = [[item objectAtIndex:2] doubleValue];
    
    return XValue;
}

-(NSString *)frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController legendForColumn:(int)column
{
    if ( self.years == nil)
        [self parseYears];
    
    NSString * yearString = [self.years objectAtIndex:column];
    
    return yearString;
}

-(NSString *) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController legendForRow:(int)row
{
    return [self.series objectAtIndex:row];
    
}

-(UIColor *) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChardViewController colorForBarAtRow:(int)row column:(int) column
{
    NSLog(@"Row %d", row);
    switch (row) {
        case 0:
            return [UIColor redColor];
            break;
            
        case 1:
            return [UIColor greenColor];
            break;
            
        case 2:
            return [UIColor blueColor];
            break;
            
        case 3:
            return [UIColor brownColor];
            break;
            
        case 4:
            return [UIColor yellowColor];
            break;
            
        case 5:
            return [UIColor grayColor];
        case 6:
            return [UIColor purpleColor];
        case 7:
            return [UIColor orangeColor];
        case 8:
            return [UIColor whiteColor];
        case 9:
            return [UIColor magentaColor];
        case 10:
            return [UIColor lightGrayColor];
        case 11:
            return [UIColor brownColor];
            
        default:
            return [UIColor colorWithRed:10*row green:250 blue:1*row alpha:1];
            break;
    }
    
}

#pragma helpers

- (NSInteger) parseYears
{
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"GFD_DJIA_Companies" ofType:@"csv"];
    
    NSArray *years = [NSArray arrayWithContentsOfCSVFile:file options:CHCSVParserOptionsRecognizesBackslashesAsEscapes];
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (int i=0; i<years.count; i++)
    {
        NSArray *temp = [years objectAtIndex:i];
        NSString *year = [temp objectAtIndex:0];
        
        if ( [ mutableArray containsObject:year] == NO)
            [mutableArray addObject:year];
    }
    
    self.years = mutableArray;
    
    return years.count;
}

- (void) generateArray
{
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"chart1" ofType:@"csv"];

    self.fields = [NSArray arrayWithContentsOfCSVFile:file options:CHCSVParserOptionsRecognizesBackslashesAsEscapes];
}

- (NSArray*) extractedSeries:(NSArray*)myCSV
{
    NSString *lastTag = @"";
    
    NSMutableArray *tags = [NSMutableArray new];
    for (int i=0; i<myCSV.count; i++)
    {
        NSArray *temp = [myCSV objectAtIndex:i];
        if ( temp.count > 1)
        {
            NSString *tag = [temp objectAtIndex:1];
            if ( [tag isEqualToString:lastTag] == NO)
            {
                [tags addObject:tag];
                lastTag = tag;
            }
        }
    }
    
    return tags;
}

- (NSArray*) getItemsInSeries:(NSString*)series
{
    NSMutableArray *items = [NSMutableArray new];
    
    for (int i=0; i < self.fields.count; i++) {
        NSArray *item = [self.fields objectAtIndex:i];
        NSString *localTag = [item objectAtIndex:1];
        if ( [localTag isEqualToString:series] == YES)
        {
            [items addObject:item];
        }
    }
    
    return items;
}
@end
