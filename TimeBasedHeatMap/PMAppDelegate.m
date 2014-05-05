//
//  PMAppDelegate.m
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMAppDelegate.h"
#import "PMHeatMapView.h"
#import "PMDataStructures.h"

#define HOURS 24
#define SECTIONS 16
#define FONT_SIZE 50

@interface PMAppDelegate() {
    NSMutableArray *_data;
}

@property (nonatomic, strong) PMHeatMapView *view;
@property (nonatomic, strong) NSTextField *label;

@end

@implementation PMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Create the data object
    _data = [NSMutableArray arrayWithCapacity:HOURS];
    // Init with empty values
    for (int i = 0; i < HOURS; i++)
        [_data addObject:[NSNull null]];
    
    // Load in the CSV
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"csv"];
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    // Loop through each line
    NSMutableArray *sectionData = nil;
    NSInteger lastHour = -1;
    for (NSString *line in lines) {
        NSArray *arr = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        // Break apart the CSV
        //  0: section
        //  1: x
        //  2: y
        //  3: hour
        //  4: frequency
        NSInteger section = [[arr objectAtIndex:0] integerValue] - 1;
        if (section == -1)
            continue; // Header row
        NSInteger x = [[arr objectAtIndex:1] integerValue]; // zero based
        NSInteger y = [[arr objectAtIndex:2] integerValue]; // zero based
        NSInteger hour = [[arr objectAtIndex:3] integerValue]; // zero based
        NSInteger frequency = [[arr objectAtIndex:4] integerValue];
        
        // Our data is lined up by
        //   hour then section { x, y, frequency }
        if (lastHour != hour) {
            // If it is already created the add it
            if (sectionData != nil) {
                [_data setObject:sectionData atIndexedSubscript:lastHour];
            }
            // Recreate the section data
            sectionData = [NSMutableArray arrayWithCapacity:SECTIONS];
            for (int i = 0; i < SECTIONS; i++)
                [sectionData addObject:[NSNull null]];
        }
        
        // Set the last hour
        lastHour = hour;
        
        // Fill up our section data with PMHeatMapData
        PMHeatMapData mapData;
        mapData.x = x;
        mapData.y = y;
        mapData.section = section + 1;
        mapData.frequency = frequency;
        NSValue *value = [NSValue valueWithBytes:&mapData objCType:@encode(PMHeatMapData)];
        [sectionData setObject:value atIndexedSubscript:section];
    }
    
    // Also, add the last line
    [_data setObject:sectionData atIndexedSubscript:lastHour];
    
    // Build the view
    self.view = [[PMHeatMapView alloc] initWithFrame:CGRectMake(0, FONT_SIZE, self.window.frame.size.width, self.window.frame.size.height - FONT_SIZE) andData:_data];
    [self.window.contentView addSubview:self.view];
    
    // Build the label
    self.label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, self.window.frame.size.width, FONT_SIZE)];
    [self.label setFont:[NSFont fontWithName:@"Helvetica" size:30.0f]];
    [self.label setTextColor:[NSColor blackColor]];
    [self.label setBezeled:NO];
    [self.label setDrawsBackground:NO];
    [self.label setEditable:NO];
    [self.label setSelectable:NO];
    [self.label setAlignment:NSCenterTextAlignment];
    [self.label setAutoresizingMask:NSViewWidthSizable |  NSViewHeightSizable];
    [self.window.contentView addSubview:self.label];
    [self updateTime];
    
    // THe timer for changing hours
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(incrementTime:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void) incrementTime:(NSTimer*)timer {
    if (self.view.currentHour >= 23) {
        self.view.currentHour = 0;
    } else {
        self.view.currentHour ++;
    }
    
    [self updateTime];
    [self.view setNeedsDisplay: YES];
}

- (void) updateTime {
    
    NSInteger adjustedTime = self.view.currentHour - 8;
    if (adjustedTime < 0)
        adjustedTime += 24;
    
    if (adjustedTime == 0) {
        [self.label setStringValue:@"12:00 a.m."];
    } else if (adjustedTime == 12) {
        [self.label setStringValue:@"12:00 p.m."];
    } else if (adjustedTime > 12) {
        NSInteger adjustedToTwelveHour = adjustedTime- 12;
        [self.label setStringValue:[NSString stringWithFormat:@"%ld:00 p.m.", adjustedToTwelveHour]];
    } else {
        [self.label setStringValue:[NSString stringWithFormat:@"%ld:00 a.m.", adjustedTime]];
    }
}

@end
