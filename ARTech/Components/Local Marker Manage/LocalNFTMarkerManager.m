//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "LocalNFTMarkerManager.h"
#import "LocalNFTMarkerData.h"

@implementation LocalNFTMarkerManager
+ (NSArray *)loadNFTMarkers {
    NSMutableArray * localNFTMarkers = [NSMutableArray new];
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
@end