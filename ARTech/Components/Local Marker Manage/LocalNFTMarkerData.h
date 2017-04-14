//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalNFTMarkerData : NSObject
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *imageUrl;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *createDate;
+ (id)dataWithUrl:(NSURL *)url;
@end