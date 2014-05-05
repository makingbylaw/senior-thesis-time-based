//
//  DataStructures.h
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct _PMHeatMapData {
    NSInteger x;
    NSInteger y;
    NSInteger section;
    NSInteger frequency;
} PMHeatMapData;
