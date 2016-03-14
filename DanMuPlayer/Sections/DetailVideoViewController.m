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

@property (nonatomic,assign)BOOL isFullScreen;  // 现在是全屏
@property (weak, nonatomic) IBOutlet UIView *backBeforePageView;  // 返回页面

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
/** 返回上一页 */
- (IBAction)backBeforePage:(id)sender {
    self.playViewController.modifyFSBB = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [DataHelper getDataSourceForDetailVideoWithURLStr:[NSString stringWithFormat:kVideoURLStr,(long)videoId] withBlock:^(NSDictionary *dic) {
        
        if ([dic[@"data"] isKindOfClass:[NSString class]] || [dic[@"data"] isKindOfClass:[NSError class]]) {
            
            // 提示加载失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"抱歉，视频信息加载失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
            
        } else {
            
            self.mainModel = dic[@"data"];
            
//            NSLog(@"拿到了model");
            __weak typeof(self)weakSelf = self;
            // 传递给视频视图
            [self.playViewController setUpWithModel:self.mainModel];
            // 调用block切换全屏
            self.playViewController.modifyFSBB = ^(BOOL yesOrNo) {
                
                _isFullScreen = !yesOrNo;
                
                UIViewController *vc = [[UIViewController alloc]init];
                [weakSelf presentViewController:vc animated:NO completion:nil];
                [vc dismissViewControllerAnimated:NO completion:nil];
            };
            
            
            // 传递给collectionView视图
            [self.infoCollectionVC loadDataWithModel:self.mainModel];
            self.infoCollectionVC.changeVideoIdBlock = ^(NSInteger videoId) {
                
                [weakSelf.playViewController setUpWithVideoId:videoId];
                
            };
            
            
            [self.aboutCollectionVC loadDataWithVideoId:self.mainModel.contentId];
            self.aboutCollectionVC.changeVideoIdBlock = ^(NSInteger one){
                [weakSelf.playViewController pushAboutVideos];
            };
        }
        
        
    }];
    
}



/** dismiss alert */
- (void)dismissAlert:(NSTimer *)timer {
    
    UIAlertController *alert = timer.userInfo[@"alert"];
    [alert dismissViewControllerAnimated:YES completion:nil];
    
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

#pragma mark - 屏幕方向
// 支持自动旋屏
- (BOOL)shouldAutorotate {
//    NSLog(@"aaa");
    
    return YES;
}
// 旋屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

// 屏幕在旋转的过程中（调节控件大小）
-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
//    NSLog(@"**** %ld",(long)[[UIApplication sharedApplication] statusBarOrientation]);
    
    
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationUnknown: {
            
            break;
        }
        case UIInterfaceOrientationPortrait: {
//            NSLog(@"现在是竖屏");
            
            if (self.isFullScreen) {
                self.backBeforePageView.hidden = YES;
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
                CALayer *layer = [self.playViewController.view.layer.sublayers firstObject];
                if ([layer isKindOfClass:[AVPlayerLayer class]]) {
                    CGRect frame = layer.frame;
                    //                frame.origin.y -= 20;
                    frame.size = CGSizeMake(kScreenHeight, kScreenWidth);
                    layer.frame = frame;
                }
                
                CGRect frame = self.playViewController.view.frame;
                frame.origin.y -= 20;
                frame.size.height += 20;
                self.playViewController.view.frame = frame;
                
                // 切换为全屏
                [self.playViewController modifyFullScreenOrNo:YES];
                
            }
            
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
//            NSLog(@"现在是横屏");
            self.backBeforePageView.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            CALayer *layer = [self.playViewController.view.layer.sublayers firstObject];
            if ([layer isKindOfClass:[AVPlayerLayer class]]) {
                CGRect frame = layer.frame;
                //                frame.origin.y += 20;
                frame.size = CGSizeMake(kScreenHeight, kScreenHeight * 8 / 16 - 20);
                layer.frame = frame;
//                NSLog(@"++%@",NSStringFromCGRect(layer.frame));
            }
            
            CGRect frame = self.playViewController.view.frame;
            frame.origin.y += 20;
            frame.size.height -= 20;
            self.playViewController.view.frame = frame;
            // 切幻为非全屏
            [self.playViewController modifyFullScreenOrNo:NO];
            break;
        }
    }
}


@end
