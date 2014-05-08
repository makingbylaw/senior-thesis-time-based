//
//  DataStructures.h
//  TimeBasedHeatMap
//
//  Created by Paul Mason on 5/4/14.
//  Copyright (c) 2014 Paul Mason. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define HOURS 24
/*
#define DATA @"data"
#define SECTIONS 16
#define SECTION_DIMENSION 4
*/
#define DATA @"data2"
#define SECTIONS 64
#define SECTION_DIMENSION 8
//*/
#define FONT_SIZE 50

typedef struct _PMHeatMapData {
    NSInteger x;
    NSInteger y;
    NSInteger section;
    NSInteger frequency;
} PMHeatMapData;
