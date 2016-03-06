//
//  DetailVideoAboutModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoAboutModel.h"

@implementation DetailVideoAboutModel

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
