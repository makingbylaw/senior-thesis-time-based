//
//  PMHeatMapView.m
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMHeatMapView.h"
#import "PMDataStructures.h"

@interface PMHeatMapView() {
}

@end

@implementation PMHeatMapView

- (id) initWithFrame:(NSRect)frameRect data:(NSArray*)data maxFrequency:(NSInteger)maxFrequency {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSLog(@"Initializing %f, %f", frameRect.size.width, frameRect.size.height);
        self.autoresizingMask = NSViewWidthSizable |  NSViewHeightSizable;
        self.data = data;
        self.currentHour = 0;
        self.maxFrequency = maxFrequency;
    }
    return self;
}

- (BOOL) isFlipped {
    return YES;
}

- (void)drawRect:(NSRect)rect {
    
    // 0,0 is bottom left so we transform
    // color the background white
    [[NSColor whiteColor] set];
    NSRectFill(rect);
    
    // Draw the heat map
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    CGContextRef contextRef = (CGContextRef)[context graphicsPort];
    
    // Get the section to draw
    id sectionObj = [self.data objectAtIndex:self.currentHour];
    if (sectionObj == [NSNull null])
        return; // Don't do anything if there is nothing to draw
    NSArray *section = sectionObj;
    
    // Work out the common width and size
    NSInteger commonWidth = MIN(self.frame.size.width, self.frame.size.height);
    NSInteger boxSize = commonWidth / SECTION_DIMENSION;
    
    // Loop through each section and draw it
    for (int i = 0; i < SECTIONS; i++) {
        
        // Unpack the data structure
        id sectionValue = [section objectAtIndex:i];
        if (sectionValue == [NSNull null]) {
            continue;
        }
        PMHeatMapData heatMapData;
        [(NSValue*)sectionValue getValue:&heatMapData];
        
        // Calculate the current color
        NSColor *color;
        
        // For now go along the red scale adjusting the value
        float alpha = (heatMapData.frequency * 1.0f) / self.maxFrequency;
        //NSLog(@"Alpha: %f", alpha);
        color = [NSColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:alpha];
        CGContextSetFillColorWithColor(contextRef, [color CGColor]);
        
        // Calculate x and y coordinates as well as size
        CGRect rect = CGRectMake(0, 0, boxSize, boxSize);
        //rect.origin.x = heatMapData.x * boxSize;
        //rect.origin.y = heatMapData.y * boxSize + 10;
        rect.origin.x = (3 - heatMapData.x) * boxSize;
        rect.origin.y = (3 - heatMapData.y) * boxSize + 10;
        
        // Draw a rectangle
        CGContextFillRect(contextRef, rect);
        
        /*
        // TEMP: Draw the section
        NSString *sectionString = [NSString stringWithFormat:@"%ld", heatMapData.section];
        [sectionString drawInRect:rect withAttributes:nil];
         */
    }
}


@end
