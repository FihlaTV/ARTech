//
//  LocalSquareMarkerData.h
//  ARTech
//
//  Created by wangyang on 2017/5/3.
//  Copyright © 2017年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalSquareMarkerData : NSObject
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *imageUrl;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *createDate;
@property (assign, nonatomic) BOOL isInternal;
+ (id)dataWithUrl:(NSURL *)url;
@end
