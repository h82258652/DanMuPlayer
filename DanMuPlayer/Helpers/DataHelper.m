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

#import "ChannelModel.h"
#import "ChannelSubModel.h"

#import "FooterModel.h"

#import "SubModel.h"

DataHelper *helper = nil;
@implementation DataHelper

+ (void)sharedHelper {
    dispatch_once_t ontToken;
    dispatch_once(&ontToken, ^{
        helper = [[DataHelper alloc]init];
    });
}

#pragma mark --传入网址，请求推荐界面数据
+ (void)getDataSourceForCommendWithURLStr:(NSString *)urlStr withName:(NSString *)name withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
        
        // 若果是数组类，则为主界面，若为字典类，则为子分区
        
        if ( [responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *array = responseObject[@"data"];
            
//            NSLog(@"******* %@",array);
            for (NSDictionary *dic in array) {
                RecommendModel *model = [[RecommendModel alloc]initWithDic:dic];
                model.nameOfMessage = name;
                [dataSource addObject:model];
                
            }
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dataSource forKey:@"dataArray"];
            block(dataDic);
        } else if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]] && [responseObject[@"data"][@"contents"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            
//            NSLog(@"******%@",name);
            
            for (NSDictionary *dic in responseObject[@"data"][@"contents"]) {
                RecommendCellModel *model = [[RecommendCellModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            dataSource = [NSMutableArray arrayWithArray:array];
            
            NSString *model_id = [responseObject[@"data"][@"id"] stringValue];
            
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dataSource forKey:@"dataArray"];
            [dataDic setValue:model_id forKey:@"model_id"];
            
            if ([responseObject[@"data"][@"menus"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *menusArray = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in responseObject[@"data"][@"menus"]) {
                    FooterModel *model = [[FooterModel alloc]initWithDic:dic];
//                    NSLog(@"%@",model.name);
                    [menusArray addObject:model];
                }
                [dataDic setValue:menusArray forKey:@"menus"];
//                NSLog(@"%@",dataDic[@"menus"]);
            }
            
            // 发送通知（当其model的值）
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:dataDic];
        } else if ([responseObject[@"data"] isKindOfClass:[NSString class]]) {
            NSLog(@"%@",responseObject[@"data"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    
}

#pragma mark --传入网址，请求频道界面数据
+ (void)getDataSourceForChannelsWithURLStr:(NSString *)urlStr withBlock:(InputBlock)block {
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
                ChannelModel *model = [[ChannelModel alloc]initWithDic:dic];
                [dataSource addObject:model];
                
            }
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDic setValue:dataSource forKey:@"dataArray"];
            
            block(dataDic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
}
#pragma mark --传入网址，请求子界面数据
+ (void)getDataSourceForSubWithURLStr:(NSString *)urlStr andParameters:(NSDictionary *)parameters withBlock:(InputBlock)block {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSLog(@"%@ /n %@",urlStr,parameters);
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"4.1.2" forHTTPHeaderField:@"appVersion"];
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
//        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"][@"list"]) {
                SubModel *model = [[SubModel alloc]initWithDic:dic];
                [array addObject:model];
            }
            NSDictionary *dic = @{@"data":array};
            block(dic);
        } else {
            NSLog(@"%@",responseObject[@"message"]);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        
    }];
}



@end
