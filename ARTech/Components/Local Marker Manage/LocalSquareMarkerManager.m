//
//  LocalSquareMarkerManager.m
//  ARTech
//
//  Created by wangyang on 2017/5/3.
//  Copyright © 2017年 wangyang. All rights reserved.
//

#import "LocalSquareMarkerManager.h"
#import "LocalSquareMarkerData.h"

@implementation LocalSquareMarkerManager
+ (NSArray *)loadSquareMarkers {
    NSMutableArray * localMarkers = [NSMutableArray new];
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@".sqmarker" inDirectory:@"."];
    
    for (NSString * subpath in paths) {
        NSURL * markerUrl = [NSURL fileURLWithPath:subpath];
        LocalSquareMarkerData *data = [LocalSquareMarkerData dataWithUrl: markerUrl];
        data.isInternal = YES;
        [localMarkers addObject: data];
    }
    return [localMarkers copy];
}

@end
