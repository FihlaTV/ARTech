//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "LocalNFTMarkerManager.h"
#import "LocalNFTMarkerData.h"

@implementation LocalNFTMarkerManager
+ (NSArray *)loadNFTMarkers {
    NSMutableArray * localNFTMarkers = [NSMutableArray new];
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@".nftmarker" inDirectory:@"."];
    
    for (NSString * subpath in paths) {
        if ([subpath hasSuffix:@".nftmarker"]) {
            NSURL * markerUrl = [NSURL fileURLWithPath:subpath];
            LocalNFTMarkerData *data = [LocalNFTMarkerData dataWithUrl: markerUrl];
            data.isInternal = YES;
            [localNFTMarkers addObject: data];
        }
    }
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *nftSetsDir = [NSURL fileURLWithPathComponents:@[docPath, @"nft_sets"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[nftSetsDir path]]) {
        NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:[nftSetsDir path]];
        for (NSString * subpath in subpaths) {
            if ([subpath hasSuffix:@".nftmarker"]) {
                NSURL * markerUrl = [nftSetsDir URLByAppendingPathComponent:subpath];
                [localNFTMarkers addObject:[LocalNFTMarkerData dataWithUrl: markerUrl] ];
            }
        }
    }
    return [localNFTMarkers copy];
}

+ (void)removeMarker:(LocalNFTMarkerData *)data {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *nftSetsDir = [NSURL fileURLWithPathComponents:@[docPath, @"nft_sets"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[nftSetsDir path]]) {
        NSArray *subpaths = [[NSFileManager defaultManager] subpathsAtPath:[nftSetsDir path]];
        for (NSString * subpath in subpaths) {
            if ([subpath hasPrefix:data.name]) {
                NSURL * markerUrl = [nftSetsDir URLByAppendingPathComponent:subpath];
                [[NSFileManager defaultManager] removeItemAtURL:markerUrl error:nil];
            }
        }
    }
}
@end
