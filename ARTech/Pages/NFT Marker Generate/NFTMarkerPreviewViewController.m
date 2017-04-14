//
// Created by wangyang on 2017/4/14.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "NFTMarkerPreviewViewController.h"


@implementation NFTMarkerPreviewViewController
- (void)viewDidLoad {
    self.title = @"NFT标记预览";
    if (self.previewImage) {
        self.view.layer.contents = (__bridge id)self.previewImage.CGImage;
    }
}
@end