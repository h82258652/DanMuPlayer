//
//  ComicDetailViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicDetailViewController.h"
#import "PlayViewController.h"
#import "ComicInfoCollectionViewController.h"
#import "DataHelper.h"
#import "MBProgressHUD.h"

#define kStr @"page=%7Bnum:1,size:50%7D"

@interface ComicDetailViewController ()<MBProgressHUDDelegate>

@property (nonatomic,strong)PlayViewController *playVC; // 播放界面
@property (nonatomic,strong)ComicInfoCollectionViewController *infoVC;  // 视频界面

@property (nonatomic,assign)NSInteger bangumisId;  // id
@property (nonatomic,strong)ComicDetailModel *mainModel;  // 主model

@property (nonatomic,strong)MBProgressHUD *hud;  // 加载提示

@end

@implementation ComicDetailViewController

- (void)loadView {
    [super loadView];
    NSLog(@"aaa");
    // 将状态栏设置为透明
//    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - 自定义方法
/** 加载数据 */
- (void)loadDataWithBangumisId:(NSInteger)BangumisId {
#warning need - 改变导航栏----
    
    self.bangumisId = BangumisId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [DataHelper getDataSourceForComicDetailWithURLStr:[NSString stringWithFormat:kComicDetailURLStr,BangumisId,kStr] withBlock:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"data"] isKindOfClass:[NSError class]]) {
            
            // 提示加载失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"抱歉，加载失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [UIView animateWithDuration:3 animations:^{} completion:^(BOOL finished) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
        } else {
            
            NSLog(@"请求到数据了");
            
            self.mainModel = dic[@"data"];
            
            // 其他设置
            [self otherAction];
        }
        
    }];
    
}

/** 其他设置 */
- (void)otherAction {
    
    [self.playVC setUpWithVideoId:self.mainModel.latestVideoComic.videoId];
    
    [self.infoVC setValueWithComicDetailModel:self.mainModel];
    
    __weak typeof(self)weakSelf = self;
    // 调用block，改变播放地址
    self.infoVC.changeVideoIdBlock = ^(NSInteger videoId) {
      
        [weakSelf.playVC setUpWithVideoId:videoId];
        
    };
    
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"comic_playView"]) {
        self.playVC = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"comic_infoView"]) {
        self.infoVC = segue.destinationViewController;
    }
    
}


@end
