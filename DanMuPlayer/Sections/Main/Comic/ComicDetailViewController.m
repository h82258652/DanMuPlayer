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
#import "OtherURLPlayerViewController.h"
#import "DataHelper.h"
#import "MBProgressHUD.h"
#import "ComicDetailVideoModel.h"
#import <AVFoundation/AVFoundation.h>

#define kStr @"page=%7Bnum:1,size:50%7D"

@interface ComicDetailViewController ()<MBProgressHUDDelegate>

@property (nonatomic,strong)PlayViewController *playVC; // 播放界面
@property (nonatomic,strong)OtherURLPlayerViewController *otherPVC;  // 网页播放界面
@property (nonatomic,strong)ComicInfoCollectionViewController *infoVC;  // 视频界面

@property (nonatomic,assign)NSInteger bangumisId;  // id
@property (nonatomic,strong)ComicDetailModel *mainModel;  // 主model

@property (nonatomic,strong)MBProgressHUD *hud;  // 加载提示
@property (weak, nonatomic) IBOutlet UIView *backBeforePageView;

@property (nonatomic,assign) BOOL isFullScreen;


@end

@implementation ComicDetailViewController

- (void)loadView {
    [super loadView];
//    NSLog(@"aaa");
    // 将状态栏设置为透明
//    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFullScreen = NO;
}

#pragma mark - 自定义方法
/** 加载数据 */
- (void)loadDataWithBangumisId:(NSInteger)BangumisId {
    
    self.bangumisId = BangumisId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [DataHelper getDataSourceForComicDetailWithURLStr:[NSString stringWithFormat:kComicDetailURLStr,(long)BangumisId,kStr] withBlock:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dic[@"data"] isKindOfClass:[NSError class]]) {
            
            // 提示加载失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"抱歉，番剧加载失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];

            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
            
        } else {
            
//            NSLog(@"请求到数据了");
            
            self.mainModel = dic[@"data"];
            
            // 其他设置
            [self otherAction];
        }
        
    }];
    
}
/** dismiss alert */
- (void)dismissAlert:(NSTimer *)timer {
    
    UIAlertController *alert = timer.userInfo[@"alert"];
    [alert dismissViewControllerAnimated:YES completion:nil];
    
}

/** 其他设置 */
- (void)otherAction {
    // 详情部分页面
    [self.infoVC setValueWithComicDetailModel:self.mainModel];
    
    ComicDetailVideoModel *model = self.mainModel.latestVideoComic;
    
    if ([model.sourceType isEqualToString:@"zhuzhan"]) {
        
        [self playAtZhuZhanWithModel:model];
    } else {
        
        [self playAtOtherWithModel:model];
    }
    
    __weak typeof(self)weakSelf = self;
    // 调用block，进入播放界面
    self.infoVC.changeVideoIdBlock = ^(ComicDetailVideoModel *vModel) {
//        NSLog(@"%@",vModel.urlMobile);
        if ([vModel.sourceType isEqualToString:@"zhuzhan"]) {  // 主站
            
//            [weakSelf.playVC setUpWithVideoId:vModel.videoId];
            [weakSelf playAtZhuZhanWithModel:vModel];
        } else {  // 网页
            
            [weakSelf playAtOtherWithModel:vModel];
        }
        
        
    };
    
}

/** 主站播放 */
- (void)playAtZhuZhanWithModel:(ComicDetailVideoModel *)model {
    
    __weak typeof(self)weakSelf = self;
    self.playVC.view.hidden = NO;
    [self.playVC setUpWithVideoId:model.videoId];
    
    // 调用block切换全屏
    self.playVC.modifyFSBB = ^(BOOL yesOrNo) {
        
        _isFullScreen = !yesOrNo;
        
        UIViewController *vc = [[UIViewController alloc]init];
        [weakSelf presentViewController:vc animated:NO completion:nil];
        [vc dismissViewControllerAnimated:NO completion:nil];
    };
}

/** 其他来源 */
- (void)playAtOtherWithModel:(ComicDetailVideoModel *)model {
    
    [self.playVC otherPlayerURLStopCurrentPage];
    self.playVC.modifyFSBB = nil;
    self.playVC.view.hidden = YES;
    
    
    // 主站没有资源，请点击下方按钮到网站观看
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"本站没有此视频资源" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
    
//    [self performSegueWithIdentifier:@"no_zhuzhan_player_segue" sender:self];
//    [self.otherPVC addWebViewWithURLStr:model.urlMobile];
}



/** 回到上一页 */
- (IBAction)backBeforePage:(id)sender {
    self.playVC.modifyFSBB = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}




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
                CALayer *layer = [self.playVC.view.layer.sublayers firstObject];
                if ([layer isKindOfClass:[AVPlayerLayer class]]) {
                    CGRect frame = layer.frame;
                    //                frame.origin.y -= 20;
                    frame.size = CGSizeMake(kScreenHeight, kScreenWidth);
                    layer.frame = frame;
                }
                
                CGRect frame = self.playVC.view.frame;
                frame.origin.y -= 20;
                frame.size.height += 20;
                self.playVC.view.frame = frame;
                
                // 切换为全屏
                [self.playVC modifyFullScreenOrNo:YES];
                
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
            CALayer *layer = [self.playVC.view.layer.sublayers firstObject];
            if ([layer isKindOfClass:[AVPlayerLayer class]]) {
                CGRect frame = layer.frame;
//                frame.origin.y += 20;
                frame.size = CGSizeMake(kScreenHeight, kScreenHeight * 8 / 16 - 20);
                layer.frame = frame;
//                NSLog(@"++%@",NSStringFromCGRect(layer.frame));
            }
            
            CGRect frame = self.playVC.view.frame;
            frame.origin.y += 20;
            frame.size.height -= 20;
            self.playVC.view.frame = frame;
            // 切幻为非全屏
            [self.playVC modifyFullScreenOrNo:NO];
            break;
        }
    }
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
    } else if ([segue.identifier isEqualToString:@"no_zhuzhan_player_segue"]) {
        self.otherPVC = segue.destinationViewController;
    }
    
}
- (void)dealloc {
//    NSLog(@"play dealloc");
}

@end
