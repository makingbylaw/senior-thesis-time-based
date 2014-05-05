//
//  PMHeatMapView.h
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PMHeatMapView : NSView

- (id) initWithFrame:(NSRect)frameRect andData:(NSArray*)data;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger currentHour;

@end
