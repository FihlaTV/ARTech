//
//  LocalSquareMarkerData.m
//  ARTech
//
//  Created by wangyang on 2017/5/3.
//  Copyright © 2017年 wangyang. All rights reserved.
//

#import "LocalSquareMarkerData.h"

@implementation LocalSquareMarkerData
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
