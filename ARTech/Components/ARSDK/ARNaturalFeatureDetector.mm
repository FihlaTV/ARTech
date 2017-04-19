//
// Created by wangyang on 2017/3/15.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "ARNaturalFeatureDetector.h"
#import <opencv2/line_descriptor.hpp>

using namespace cv;
using namespace cv::xfeatures2d;

@interface ARNaturalFeatureDetector () {
    Ptr<SURF> detector;
    BOOL isFeatureMatValid;
}

@end

@implementation ARNaturalFeatureDetector

- (instancetype)init {
    self = [super init];
    if (self) {
        int minHessian = 400;
        Ptr<SURF> surf = SURF::create(minHessian);
        detector.swap(surf);
        isFeatureMatValid = NO;
    }
    return self;
}

- (std::vector<cv::KeyPoint>)detectFeatures:(uint8_t *)imageData size:(CGSize)imgSize {
    uint8_t *imageDataCopy = (uint8_t *)malloc(imgSize.width * imgSize.height);
    memcpy(imageDataCopy, imageData, imgSize.width * imgSize.height);
    Mat img = cv::Mat(imgSize.width, imgSize.height,CV_8UC1);
    img.data = imageDataCopy;


    std::vector<KeyPoint> keypoints;
    detector->detect(img, keypoints);
    return keypoints;
}

@end
