//
// Created by wangyang on 2017/3/16.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARBaseViewController.h"

@class LocalSquareMarkerData;

@interface SquareARViewController : ARBaseViewController
@property (strong, nonatomic) LocalSquareMarkerData *marker;
@end
