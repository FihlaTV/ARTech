//
// Created by wangyang on 2017/4/19.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelManager : NSObject
+ (NSArray *)load3DModels;
+ (void)select3DModel:(NSString *)path;
+ (NSString *)loadSelected3DModel;
@end