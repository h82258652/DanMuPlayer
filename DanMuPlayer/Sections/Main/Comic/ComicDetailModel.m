//
//  ComicDetailModel.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicDetailModel.h"

@implementation ComicDetailModel

/** 初始化 */
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.videosArr = [NSMutableArray arrayWithCapacity:1];
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"latestVideo"]) {
//        NSLog(@"%@",value);
        
        ComicDetailVideoModel *model = [[ComicDetailVideoModel alloc]initWithDic:value];
        self.latestVideoComic = model;
    } else if ([key isEqualToString:@"videos"]) {
        
        for (NSDictionary *dic in value) {
//            NSLog(@"%@",value);
//            NSLog(@"%@",value);
            ComicDetailVideoModel *model = [[ComicDetailVideoModel alloc]initWithDic:dic];
            [self.videosArr addObject:model];
        }
        
    }
    
}

@end
