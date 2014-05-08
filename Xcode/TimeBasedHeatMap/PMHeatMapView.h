//
//  PMHeatMapView.h
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PMHeatMapView : NSView

- (id) initWithFrame:(NSRect)frameRect data:(NSArray*)data maxFrequency:(NSInteger)maxFrequency;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger currentHour;
@property (nonatomic, assign) NSInteger maxFrequency;

@end
