//
//  DetailVideoViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "PlayViewController.h"
#import "DetailVideoInfoCollectionViewController.h"
#import "DetailVideoAboutCollectionViewController.h"

#import "DetailVideoModel.h"

#import "DataHelper.h"


@interface DetailVideoViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;

@property (nonatomic,strong) PlayViewController *playViewController;  // 播放视图控制器
@property (nonatomic,strong) DetailVideoInfoCollectionViewController *infoCollectionVC;  // 视频信息
@property (nonatomic,strong) DetailVideoAboutCollectionViewController *aboutCollectionVC;  // 视频相关


@property (nonatomic,strong)DetailVideoModel *mainModel;  // 主model
@property (nonatomic,assign)NSInteger videoId;  // 视频id

@end

@implementation DetailVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self.infoBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.aboutBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.infoBtn.selected = YES;
    
    self.mainScrollView.delegate = self;
    
    [self.navigationController.navigationBar setBackgroundColor:[kThemeColor colorWithAlphaComponent:0]];
}

#pragma mark - 自定义方法
// btn的触发事件
- (IBAction)handleAction:(UIButton *)sender {
    
    [self changeBtnStateWithText:sender.titleLabel.text];
    CGPoint point;
    if ([sender.titleLabel.text isEqualToString:@"视频信息"]) {
        
        point = CGPointMake(0, 0);
    } else {
        
        point = CGPointMake(CGRectGetWidth(self.mainScrollView.frame), 0);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainScrollView.contentOffset = point;
    }];
    
}
/** 改变btn的状态 */
- (void)changeBtnStateWithText:(NSString *)text {
    
    if ([text isEqualToString:@"视频信息"]) {
        self.infoBtn.selected = YES;
        self.aboutBtn.selected = NO;
        
    } else {
        self.infoBtn.selected = NO;
        self.aboutBtn.selected = YES;
    }
}

#pragma mark <UIScrollViewDelegate>
// 滑动停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.mainScrollView.contentOffset.x / CGRectGetWidth(self.mainScrollView.frame);
    
    switch (index) {
        case 0:
            [self changeBtnStateWithText:@"视频信息"];
            break;
        case 1:
            [self changeBtnStateWithText:@"相关推荐"];
            break;
        default:
            break;
    }
}

/** 请求数据 */
- (void)loadDataWithVideoId:(NSInteger)videoId {
    
    self.videoId = videoId;
    [DataHelper getDataSourceForDetailVideoWithURLStr:[NSString stringWithFormat:kVideoURLStr,videoId] withBlock:^(NSDictionary *dic) {
        self.mainModel = dic[@"data"];
        
        NSLog(@"拿到了model");
        // 传递给视频视图
        [self.playViewController setUpWithModel:self.mainModel];
        
        __weak typeof(self)weakSelf = self;
        // 传递给collectionView视图
        [self.infoCollectionVC loadDataWithModel:self.mainModel];
        self.infoCollectionVC.changeVideoIdBlock = ^(NSInteger videoId) {
          
            [weakSelf.playViewController setUpWithVideoId:videoId];
            
        };
        
        
        [self.aboutCollectionVC loadDataWithVideoId:self.mainModel.contentId];
        self.aboutCollectionVC.changeVideoIdBlock = ^(NSInteger one){
            [weakSelf.playViewController pushAboutVideos];
        };
        
        
    }];
    
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
    
    if ([segue.identifier isEqualToString:@"play_vc_segue"]) {
        self.playViewController = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"info_vc_segue"]) {
        self.infoCollectionVC = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"about_vc_segue"]) {
        self.aboutCollectionVC = segue.destinationViewController;
    }
    
    
    
}


@end
