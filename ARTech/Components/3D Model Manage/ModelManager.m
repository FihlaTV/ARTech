//
// Created by wangyang on 2017/4/19.
// Copyright (c) 2017 wangyang. All rights reserved.
//

#import "ModelManager.h"

const NSString * kSelected3DModelKey = @"kSelected3DModelKey";

@implementation ModelManager
+ (NSArray *)load3DModels {
    NSArray * paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"fbx" inDirectory:@"./"];
    return paths;
}

+ (void)select3DModel:(NSString *)path {
    [[NSUserDefaults standardUserDefaults] setObject:path forKey:kSelected3DModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)loadSelected3DModel {
    NSString *selectedModelPath = [[NSUserDefaults standardUserDefaults] objectForKey:kSelected3DModelKey];
    if (!selectedModelPath) {
        return [[self load3DModels] firstObject];
    }
    return selectedModelPath;
}
@end