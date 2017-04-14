//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "LocalNFTMarkerData.h"


@implementation LocalNFTMarkerData
+ (id)dataWithUrl:(NSURL *)url {
    return [[self alloc] initWithUrl:url];
}

- (instancetype)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        NSURL *baseUrl = [self.url URLByDeletingPathExtension];
        self.imageUrl = [baseUrl URLByAppendingPathExtension:@"jpg"];
        self.name = [baseUrl lastPathComponent];
    }
    return self;
}
@end