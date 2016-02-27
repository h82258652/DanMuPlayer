//
//  DataHelper.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DataHelper.h"
#import "AFHTTPSessionManager.h"
#import "RecommendModel.h"
#import "RecommendCellModel.h"

DataHelper *helper = nil;
@implementation DataHelper

+ (void)sharedHelper {
    dispatch_once_t ontToken;
    dispatch_once(&ontToken, ^{
        helper = [[DataHelper alloc]init];
    });
}
+ (void)getDataSourceForCommendWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *array = responseObject[@"data"];
            
//            NSLog(@"******* %@",array);
            for (NSDictionary *dic in array) {
                RecommendModel *model = [[RecommendModel alloc]initWithDic:dic];
                [dataSource addObject:model];
                
                
            }
            block(dataSource);
        } else if ([responseObject[@"data"][@"contents"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"contents"]) {
                RecommendCellModel *model = [[RecommendCellModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            dataSource = [NSMutableArray arrayWithArray:array];
            
            NSString *model_id = [responseObject[@"data"][@"id"] stringValue];
            
            // 发送通知（当其model的值）
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModel" object:nil userInfo:@{@"dataArray":dataSource,@"model_id":model_id}];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
}

@end
