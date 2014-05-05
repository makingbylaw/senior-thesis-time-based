//
//  PMHeatMapView.m
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import "PMHeatMapView.h"
#import "PMDataStructures.h"

// Copy by default
#define SECTIONS 16

@implementation PMHeatMapView

- (id) initWithFrame:(NSRect)frameRect andData:(NSArray*)data {
    self = [super initWithFrame:frameRect];
    if (self) {
        NSLog(@"Initializing %f, %f", frameRect.size.width, frameRect.size.height);
        self.autoresizingMask = NSViewWidthSizable |  NSViewHeightSizable;
        self.data = data;
        self.currentHour = 0;
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
    NSInteger boxSize = commonWidth / 4;
    
    // Loop through each section and draw it
    for (int i = 0; i < SECTIONS; i++) {
        
        // Unpack the data structure
        id sectionValue = [section objectAtIndex:i];
        if (sectionValue == [NSNull null]) {
            NSLog(@"Skipped %d", i);
            continue;
        }
        PMHeatMapData heatMapData;
        [(NSValue*)sectionValue getValue:&heatMapData];
        
        // Calculate the current color
        NSColor *color;
        if (i % 2 == 0) {
            color = [NSColor redColor];
        } else {
            color = [NSColor blueColor];
        }
        CGContextSetFillColorWithColor(contextRef, [color CGColor]);
        
        // Calculate x and y coordinates as well as size
        CGRect rect = CGRectMake(0, 0, boxSize, boxSize);
        rect.origin.x = heatMapData.x * boxSize;
        rect.origin.y = heatMapData.y * boxSize;
        
        // Draw a rectangle
        CGContextFillRect(contextRef, rect);
    }
}


@end