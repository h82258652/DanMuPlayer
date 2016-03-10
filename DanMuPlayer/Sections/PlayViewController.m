//
//  PlayViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "PlayViewController.h"
#import "DetailVideoListModel.h"
#import "DanmakuView.h"
#import "DanmakuRenderer.h"

#import "DataHelper.h"
#import "AFHTTPSessionManager.h"

#import <AVFoundation/AVFoundation.h>

@interface PlayViewController ()<DanmakuDelegate>

{
    
    id observerObject;  // 接收改值是用来移除对播放进度的监听,在移除观察者使用到
}

@property (nonatomic,strong)DetailVideoModel *mainModel;  // 主model
@property (nonatomic,assign)NSInteger videoId;  // 视频id
@property (nonatomic,strong)NSDictionary *infoDic;  // 信息字典

@property (nonatomic,strong)AVPlayer *mainPlayer;  // 播放器
@property (nonatomic,strong)AVPlayerItem *currentItem; // 当前播放器的item


@property (weak, nonatomic) IBOutlet UIButton *palyerBtn;  // 播放按钮

@property (nonatomic,strong)DanmakuView *danmukuView;  // 弹幕库
@property (nonatomic,strong)NSMutableArray *danmukuArray;  // 弹幕库数组

@property (weak, nonatomic) IBOutlet UIView *verticalControlView;  // 竖屏要显示的控制视图
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabelV;  // 当前播放进度
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabelV;  // 总时间
@property (weak, nonatomic) IBOutlet UISlider *progressSliderV;

@property (weak, nonatomic) IBOutlet UIView *horizontalControlBottomView;  // 横屏要显示的下方控制器视图
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabelH;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabelH;
@property (weak, nonatomic) IBOutlet UITextField *danMuTextField;
@property (weak, nonatomic) IBOutlet UISlider *progressSliderH;

@property (weak, nonatomic) IBOutlet UIView *horizontalControlTopView;  // 横屏要显示的上方控制器视图
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;  // 标题视图

@property (weak, nonatomic) IBOutlet UIView *allDefinitionView;  // 全部清晰度
@property (weak, nonatomic) IBOutlet UIButton *nowDefinitionBtn;  // 当前选择的清晰度


@property (nonatomic,assign)BOOL isFullScreenOrNO;  // 是否是全屏
@property (nonatomic,strong)NSTimer *hiddenControlViewAfter;  // 在一定时间后隐藏控制器视图的时间戳

// 控制器位移
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YOfBottomViewV;  // 竖屏 下方位移

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YOfBottomViewH;  // 横屏 下方位移
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *YOfTopViewH;  // 横屏 上方位移
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfDefinitionView;  // 清晰度视图高度

@property (nonatomic,assign)BOOL nowIsSwitchDetifinition;  // 现在是否是在切换清晰度
@property (nonatomic,assign)BOOL isNextIn;  // 第二次及之后设置选集（即切换视频）

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *clickTapOnce;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *clickTapTwice;

@property (nonatomic,assign)CMTime currentCMTime;  // 播放进度
@property (nonatomic,assign)CGFloat totalTimeOfVideo;  // 视频总时长


@end

@implementation PlayViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 默认开启时间戳
    self.hiddenControlViewAfter = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(changeControlViewHiddenOrNo) userInfo:nil repeats:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化设置
    self.isFullScreenOrNO = NO;
    self.allDefinitionView.hidden = YES;
    self.horizontalControlTopView.hidden = YES;
    self.horizontalControlBottomView.hidden = YES;
    self.nowIsSwitchDetifinition = NO;
    
    
    
    [self.clickTapOnce requireGestureRecognizerToFail:self.clickTapTwice];
    
    
//    [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nil) name: object:<#(nullable id)#>
    
}

#pragma mark - 自定义方法

/** 赋值 */
- (void)setUpWithModel:(DetailVideoModel *)model {
    self.mainModel = model;
    
//    NSLog(@"%@",model.title);
    
    
    DetailVideoListModel *listModel = [model.videos firstObject];
    [self loadDataWithVideoId:listModel.videoId];
    
}
/** 赋值 */
- (void)setUpWithVideoId:(NSInteger)videoId {
    
    self.videoId = videoId;
    [self loadDataWithVideoId:videoId];
    
}


/** 请求数据(播放地址) */
- (void)loadDataWithVideoId:(NSInteger)videoId {
    
    // 判断是否收藏过，添加收藏按钮
//    [self whetherCollection];
    
//    NSLog(@"%ld",videoId);
    self.videoId = videoId;
    
    [DataHelper getDataSourceWithURLStr:[NSString stringWithFormat:kVideoRealSourceURLStr,videoId] withBlock:^(NSDictionary *dic) {
        
        self.isNextIn = YES;
        
        // 请求到了播放地址
        self.infoDic = dic[@"data"];
        NSLog(@"请求到了播放地址");
        
        
        // 默认加载第一个视频
        NSDictionary *fileDic = [self.infoDic[@"files"] firstObject];
        NSString *urlStr = [fileDic[@"url"] firstObject];
        
        // 设置默认播放状态
        [self setUpAvPlayerWithURL:[NSURL URLWithString:urlStr]];
        
        // 设置全部频道数据
        [self setUpAllDefinitionView];
        
        // 请求并封装弹幕数据
//        [self modifyDanMuKuSource];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:kDanMuURLStr,self.videoId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"+++%@",responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                [self modifyDanMuKuSourceWithArray:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        // 初始化弹幕库
//        [self setUpDanMuKu];
        
        self.videoTitleLabel.text = self.infoDic[@"title"];
        
        
        
        
        
    }];
}

/** 设置视频层 */
- (void)setUpAvPlayerWithURL:(NSURL *)URL{
    
    if (self.mainPlayer && self.mainPlayer.rate == 0) {
        [self.mainPlayer pause];
        [self.danmukuView stop];
        
        if ([self.palyerBtn.titleLabel.text isEqualToString:@"暂停"]) {
            [self.palyerBtn setTitle:@"播放" forState:UIControlStateNormal];
        }
    }
    
    self.currentCMTime = self.mainPlayer.currentTime;
    
    if (self.nowIsSwitchDetifinition || self.isNextIn) {
        // 移除监听者
        [self removeObserver:self.currentItem];
    }
    
    self.currentItem = [AVPlayerItem playerItemWithURL:URL];
    
    if (self.mainPlayer == nil) {
        
        self.mainPlayer = [AVPlayer playerWithPlayerItem:self.currentItem];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.mainPlayer];
        layer.frame = self.view.frame;
        [self.view.layer insertSublayer:layer atIndex:0];
    } else {
        
        [self.mainPlayer replaceCurrentItemWithPlayerItem:self.currentItem];
    }
    
    // 添加定时器,监听播放进度
    [self addCurrentTimeTimer];
    
    // 添加观察者,观察播放状态与缓冲
    [self addObserverToPlayItem:self.currentItem];
    
    // 如果是切换清晰度，则自动播放
    if (self.nowIsSwitchDetifinition) {
        
        // 跳转
        [self.mainPlayer seekToTime:self.currentCMTime];
        
        // 播放
//        [self.mainPlayer play];
        

    }
    
}

/** 创建所有清晰度选项视图 */
- (void)setUpAllDefinitionView {
    
    if ([self.allDefinitionView viewWithTag:180]) {
        // 如果180tag的视图创立了
        for (UIView *view in self.allDefinitionView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
    }
    
    // 创建btn
    [self.infoDic[@"files"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            [self.nowDefinitionBtn setTitle:obj[@"description"] forState:UIControlStateNormal];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5, 3 + 30 * idx, 70, 30);
        [self.allDefinitionView addSubview:btn];
        btn.tag = 180 + idx;
        [btn setTitle:obj[@"description"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(switchDefinitionAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
    self.heightOfDefinitionView.constant = 33 * [self.infoDic[@"files"] count] + 3;
}

#pragma mark - 视频播放控制
/** 播放/暂停 */
- (IBAction)playOrPause:(UIButton *)sender {
    
    // 如果播放速率小于0，则开始播放
    if (self.mainPlayer.rate == 0) {
        
        // 开始播放
        [self.mainPlayer play];
        // 开启弹幕
        [self.danmukuView start];
        
        // 隐藏控制器视图
        [self displayCotrollView:NO];
        
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
    } else {
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        
        // 暂停播放
        [self.mainPlayer pause];
        [self.danmukuView pause];
    }
    
}

/** 拖动slider */
- (IBAction)modifyProgress:(UISlider *)sender {
    
    // 暂停播放
    [self.mainPlayer pause];
    int32_t timescale = self.mainPlayer.currentTime.timescale;
    int64_t value = sender.value * CMTimeGetSeconds(self.mainPlayer.currentItem.duration) * timescale;
    CMTime time = CMTimeMake(value, timescale);
    [self.mainPlayer seekToTime:time];
    [self.mainPlayer play];
    
}


#pragma mark - 界面处理
/** 全屏 */
- (IBAction)switchFullScreen:(UIButton *)sender {
    
    
    // 选择之后隐藏清晰度视图
    self.allDefinitionView.hidden = YES;
    
    
    if (self.isFullScreenOrNO) {  // 退出全屏
        
        // 状态栏切换
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.navigationBarHidden = NO;

        self.view.superview.transform = CGAffineTransformRotate(self.view.superview.transform, -M_PI_2);
        
        CGRect frame = self.view.superview.frame;
        frame.origin = CGPointMake(0, 20);
        frame.size = CGSizeMake(kScreenWidth,kScreenWidth * 8 / 16);
        self.view.superview.frame = frame;
        
//        frame = self.danmukuView.frame;
//        frame.size = CGSizeMake(kScreenWidth, kScreenWidth * 8 / 16);
        self.danmukuView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 8 / 16 - 20);
        
        // 控件切换
        
        self.verticalControlView.hidden = NO;
        self.horizontalControlTopView.hidden = YES;
        self.horizontalControlBottomView.hidden = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.YOfBottomViewV.constant = 0;
            
            self.YOfTopViewH.constant = -50;
            self.YOfBottomViewH.constant = -50;
            
        }];
        
//        [DanmakuRenderer setCanvasWidth:kScreenWidth + 100];
        
        self.isFullScreenOrNO = NO;
    } else {  // 进入全屏
        
        
        // 状态栏切换
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
        
        self.view.superview.layer.anchorPoint = CGPointMake(0, 0);
        
        self.view.superview.transform = CGAffineTransformRotate(self.view.superview.transform, M_PI_2);
        
        CGRect frame = self.view.superview.frame;
        frame.origin = CGPointMake(kScreenWidth, 0);
        frame.size = CGSizeMake(kScreenWidth, kScreenHeight);
        self.view.superview.frame = frame;
        
//        frame = self.danmukuView.frame;
//        frame.size = CGSizeMake(kScreenHeight, kScreenWidth);
        self.danmukuView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
        
        // 控件切换
        
        self.verticalControlView.hidden = YES;
        self.horizontalControlTopView.hidden = NO;
        self.horizontalControlBottomView.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.YOfBottomViewV.constant = -50;
            
            self.YOfTopViewH.constant = 0;
            self.YOfBottomViewH.constant = 0;
            
        }];
        
//        [DanmakuRenderer setCanvasWidth:kScreenHeight + 200];
        self.isFullScreenOrNO = YES;
    }
    
    // 取到当前的播放layer
    CALayer *layer = [self.view.layer.sublayers firstObject];
    // 改变frame
    [UIView animateWithDuration:0.5 animations:^{
        
        layer.frame = self.view.frame;
    }];
    
    // 切换之后，显示控制器视图
    [self displayCotrollView:YES];
    
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}
/** 切换清晰度事件 */
- (void)switchDefinitionAction:(UIButton *)sender {
    
    // 选择之后隐藏
    self.allDefinitionView.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:[self.infoDic[@"files"][sender.tag - 180][@"url"] firstObject]];
    AVURLAsset *set = (AVURLAsset *)self.currentItem.asset;
    
    if ([set.URL isEqual:url]) {
        // 与当前播放的网址一样，不用切换
        
        NSLog(@"不用切换");
    } else {
        
        [self.mainPlayer pause];  // 暂停播放
        [self.danmukuView pause];  // 暂停弹幕
        
        if ([self.palyerBtn.titleLabel.text isEqualToString:@"暂停"]) {
            [self.palyerBtn setTitle:@"播放" forState:UIControlStateNormal];
        }
        
        self.nowIsSwitchDetifinition = YES;
        
        // 与当前播放的网址不一样，需要切换
        [self setUpAvPlayerWithURL:url];
        NSLog(@"需要切换");
        
        
        
        
        NSString *detifinitionTitle = self.infoDic[@"files"][sender.tag - 180][@"description"];
        [self.nowDefinitionBtn setTitle:detifinitionTitle forState:UIControlStateNormal];
    }
    
    
    
}
/** 调节控制器的显示与消失 */
- (void)changeControlViewHiddenOrNo {
    
//    [self.hiddenControlViewAfter setFireDate:[NSDate distantFuture]];  // 关闭一定事件后隐藏控制器视图的时间戳
//    NSLog(@"时间戳事件");
    
    // 隐藏控制器视图
    [self displayCotrollView:NO];
    
    
}
/** 单击屏幕事件 */

- (IBAction)clictPlayerViewOnce:(UITapGestureRecognizer *)sender {
    
//    self.allDefinitionView.hidden = YES;  // 只要做了操作，就隐藏全部频道视图
    
    // 单击显示控制器视图
    
//    NSLog(@"%f",self.hiddenControlViewAfter.fireDate.timeIntervalSinceNow);
    
    if (self.hiddenControlViewAfter.fireDate.timeIntervalSinceNow < 5) {  // 说明时间戳是开启的
//        // 关闭时间戳
        [self.hiddenControlViewAfter setFireDate:[NSDate distantFuture]];
        // 手动立即隐藏控制器视图
        [self displayCotrollView:NO];
//        NSLog(@"aaa");
    } else {  // 时间戳是关闭状态
        
        // 显示控制器视图
        [self displayCotrollView:YES];
//        NSLog(@"bbb");
        
        [self.hiddenControlViewAfter setFireDate:[NSDate dateWithTimeIntervalSinceNow:5]];  // 显示一定事件后隐藏控制器视图
    }
}
/** 双击屏幕事件 */
- (IBAction)clickPlayerViewTwice:(UITapGestureRecognizer *)sender {
    
    self.allDefinitionView.hidden = YES;  // 只要做了操作，就隐藏全部频道视图
    
    // 双击暂停或继续播放
    
    if (self.mainPlayer.rate == 0) {
        [self.mainPlayer play];
        [self.danmukuView start];
        
        if ([self.palyerBtn.titleLabel.text isEqualToString:@"播放"]) {
            [self.palyerBtn setTitle:@"暂停" forState:UIControlStateNormal];
        }
    } else {
        [self.mainPlayer pause];
        [self.danmukuView pause];
        if ([self.palyerBtn.titleLabel.text isEqualToString:@"暂停"]) {
            [self.palyerBtn setTitle:@"播放" forState:UIControlStateNormal];
        }
    }
}
/** 控制器视图的显示与隐藏 */
- (void)displayCotrollView:(BOOL)display {
    
    self.allDefinitionView.hidden = YES;  // 只要做了操作，就隐藏全部频道视图
    
    if (display) {  // 显示
//        [self.hiddenControlViewAfter setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];  // 打开时间戳
        
            
            if (self.isFullScreenOrNO) {  // 全屏
                
                [UIView animateWithDuration:1 animations:^{
                    self.YOfBottomViewH.constant = 0;
                    self.YOfTopViewH.constant = 0;
                }];
            } else {  // 非全屏
                
                self.verticalControlView.hidden = NO;
            }
         
            self.palyerBtn.hidden = NO;
        
        
    } else { // 隐藏
        
        // 关闭时间戳
//        [self.hiddenControlViewAfter setFireDate:[NSDate distantFuture]];
        
            
            if (self.isFullScreenOrNO) {  // 全屏
                [UIView animateWithDuration:1 animations:^{
                    
                    self.YOfBottomViewH.constant = -50;
                    self.YOfTopViewH.constant = -50;
                }];
            } else {  // 非全屏
                
                self.verticalControlView.hidden = YES;
            
            }
            if (self.mainPlayer.rate != 0) {
                self.palyerBtn.hidden = YES;
            }
        
    }
    
}


#pragma mark - 横屏上方视图控制器方法
/** 返回到上一界面 */
- (IBAction)backToBeforePage:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}
/** 切换清晰度视图显示 */
- (IBAction)switchDefinition:(UIButton *)sender {
    self.allDefinitionView.hidden = !self.allDefinitionView.hidden;
}
/** 关闭弹幕 */
- (IBAction)closeOrOpenDanMu:(UIButton *)sender {
    
    if (self.danmukuView.isPlaying) {
        [self.danmukuView stop];
        [sender setTitle:@"开弹幕" forState:UIControlStateNormal];
    } else {
        [self.danmukuView start];
        [sender setTitle:@"关弹幕" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 其他方法

// 定时器方法,监测播放进度
- (void)addCurrentTimeTimer
{
    __weak typeof(self)weakSelf = self;
    //observerObject,接收改值是用来移除对播放进度的监听,在移除观察者使用到
    observerObject = [_mainPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:nil usingBlock:^(CMTime time) {
        
        NSLog(@"正在播放");
        
        // 计算进度值
        int current = CMTimeGetSeconds(weakSelf.mainPlayer.currentTime);
        
        if (weakSelf.nowIsSwitchDetifinition) {  // 此时处于切换清晰度的过程中
            
            // 如果进度大于等于切换清晰度之前的进度值，就删除老的的播放层，开始记录进的播放层
            if (CMTimeGetSeconds(weakSelf.currentCMTime) <= current) {
                // 移除当前播放层
//                NSLog(@"%@",weakSelf.view.layer.sublayers);
                NSLog(@"切换完成");
                
                weakSelf.nowIsSwitchDetifinition = NO;
                
                [weakSelf.mainPlayer play];
                [weakSelf.danmukuView start];
                if ([weakSelf.palyerBtn.titleLabel.text isEqualToString:@"播放"]) {
                    [weakSelf.palyerBtn setTitle:@"暂停" forState:UIControlStateNormal];
                }
                
            }
            
        } else {  // 记录新的播放进度
        
        
            // 获取分钟
            int currentMin = current / 60;
            // 获取秒
            int currentSec = current % 60;
            
            //判断
            if (current != 0) {
                NSString *timeStr = [NSString stringWithFormat:@"%.2d:%.2d",currentMin,currentSec];
                weakSelf.currentTimeLabelH.text = timeStr;
                weakSelf.currentTimeLabelV.text = timeStr;
            }else
            {
                weakSelf.currentTimeLabelV.text = @"00:00";
                weakSelf.currentTimeLabelH.text = @"00:00";
            }
            
            // 更新slider进度条
            CGFloat currentTime = CMTimeGetSeconds(weakSelf.mainPlayer.currentItem.currentTime) / CMTimeGetSeconds(weakSelf.mainPlayer.currentItem.duration);
            [weakSelf.progressSliderH setValue:currentTime animated:YES];
            weakSelf.currentCMTime = time;
            

        }
        
        
        //播放结束,停止播放
        if (CMTimeGetSeconds(weakSelf.mainPlayer.currentItem.duration) != 0 && CMTimeGetSeconds(weakSelf.mainPlayer.currentItem.currentTime) == CMTimeGetSeconds(weakSelf.mainPlayer.currentItem.duration)) {
            [weakSelf.mainPlayer pause];
        }
    }];
    
}
// 添加观察者,观察播放状态与缓冲
- (void)addObserverToPlayItem:(AVPlayerItem *)avplayerItem
{
    // 监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [avplayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监控缓冲进度
    [avplayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

//KVO监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 获取item
    AVPlayerItem *avPlayerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        // 获取当前的播放状态
        AVPlayerStatus status = [[change objectForKey:@"new"]intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            // 获取音乐播放的总时长
            CMTime totalTime = avPlayerItem.duration;
            //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数s
            self.totalTimeOfVideo = (CGFloat)totalTime.value/totalTime.timescale;
            int musicM = self.totalTimeOfVideo / 60;
            int musicS = (int)self.totalTimeOfVideo % 60;
            //给总时长label添加时间
            self.totalTimeLabelH.text = [NSString stringWithFormat:@"/%.2d:%.2d",musicM,musicS];
            self.totalTimeLabelV.text = [NSString stringWithFormat:@"/%.2d:%.2d",musicM,musicS];
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
//        // 获得缓冲数组
//        NSArray *array = avPlayerItem.loadedTimeRanges;
//        // 本次缓冲时间范围
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
//        // 获得开始时间
//        float startSeconds = CMTimeGetSeconds(timeRange.start);
//        // 获得总时间
//        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
//        //缓冲总长度
//        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
////        NSLog(@"共缓冲：%.2f",totalBuffer);
//        [self.bufferProgress setProgress:totalBuffer animated:YES];
//        
//        
        NSLog(@"正在缓冲");
    }
    
}


//移除观察者
- (void)removeObserver:(AVPlayerItem *)avplayerItem
{
    //移除对播放状态\缓冲进度\播放进度的监听
    if (avplayerItem != nil) {
        
        [avplayerItem removeObserver:self forKeyPath:@"status"];
        [avplayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.mainPlayer removeTimeObserver:observerObject];
    }
    else
    {
        NSLog(@"没有资源对象");
    }
    
    
}

#pragma mark - 弹幕处理
/** 初始化弹幕库 */
- (void)setUpDanMuKu {
    if (!self.danmukuView) {        
        DanmakuConfiguration *configuration = [[DanmakuConfiguration alloc]init];
        configuration.duration = 6.5;  // 间隔
        configuration.paintHeight = 21;  // 绘制区域高度
        configuration.fontSize = 17;  // 弹幕字体大小
        configuration.largeFontSize = 19;  // 弹幕字体最大号
        configuration.maxLRShowCount = 30;
        configuration.maxShowCount = 45;  // 显示的弹幕总数的最大值
        
        CGRect rect =  CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));  // 弹幕的范围
        self.danmukuView = [[DanmakuView alloc]initWithFrame:rect Configuration:configuration];
        self.danmukuView.delegate = self;
        [self.view insertSubview:self.danmukuView atIndex:1];
        
        // 设置弹幕的起始位置
        [DanmakuRenderer setCanvasWidth:kScreenHeight];
    }
    
    // 获取弹幕库文件
//    NSString *danmukufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
//    NSArray *danmukus= [NSArray arrayWithContentsOfFile:danmukufile];
    // 将弹幕数组传给弹幕库
    //    [self.danmukuView prepareDanmakus:danmukus];
    [self.danmukuView prepareDanmakuSources:self.danmukuArray];
}
/** 将弹幕数组封装成model */
- (void)modifyDanMuKuSourceWithArray:(NSArray *)arr {
    if (self.danmukuArray) {
        [self.danmukuArray removeAllObjects];
    } else {
        self.danmukuArray = [NSMutableArray arrayWithCapacity:1];
    }
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDanMuURLStr,self.videoId]];
//    NSLog(@"%@",[NSString stringWithFormat:kDanMuURLStr,self.videoId]);
//    NSData *data = [NSData dataWithContentsOfURL:url];
    
    
    
//    NSArray *sourceArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"++++%@",array);
    NSArray *sourceArr = [NSArray arrayWithArray:arr];
    sourceArr = [sourceArr sortedArrayUsingComparator:^NSComparisonResult(NSArray *  _Nonnull obj1, NSArray *  _Nonnull obj2) {
        NSComparisonResult result = [[NSNumber numberWithUnsignedInteger:obj1.count] compare:[NSNumber numberWithUnsignedInteger:obj2.count]];
        return result;
    }];
    
    [sourceArr[2] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"*****%@",obj);
        // 格式化弹幕信息
        NSString *str1 = obj[@"c"];
        NSArray *array = [str1 componentsSeparatedByString:@","];
        //        NSLog(@"%@",array);
        NSMutableString *str = [NSMutableString stringWithCapacity:0];
        // 参数一：时间
        [str appendFormat:@"%f",[array[0] doubleValue] * 1000];
        // 参数二: 弹幕模式
        
        switch ([array[2] intValue]) {
            case 1:
                [str appendString:@",0"];
                break;
            case 4:
                [str appendString:@",2"];
                break;
            case 5:
                [str appendString:@",1"];
                break;
            default:
                break;
        }
        // 参数三: 字号
        switch ([array[3] intValue]) {
            case 16:
            case 25:
                [str appendString:@",0"];
                break;
            case 37:
                [str appendString:@",1"];
                break;
            default:
                break;
        }
        // 参数四: 颜色
        [str appendString:@",FFFFFF"];
        // 参数五: 发送弹幕的ID
        [str appendFormat:@",%@",array[4]];
        //        NSLog(@"%@",str);
        // 创建一条弹幕信息
        DanmakuSource *danmu = [DanmakuSource createWithP:str M:obj[@"m"]];
        [self.danmukuArray addObject:danmu];
    }];
    
    // 初始化弹幕库
    [self setUpDanMuKu];
}

#pragma mark -DanmakuDelegate
- (float)danmakuViewGetPlayTime:(DanmakuView *)danmakuView {
    // 播放进度
    //    NSLog(@"%f",self.progressOfPlay);
    return CMTimeGetSeconds(self.currentCMTime);
}
- (BOOL)danmakuViewIsBuffering:(DanmakuView *)danmakuView {
    // 视频播放缓冲状态，如果设为YES，不会绘制新弹幕，已绘制弹幕会继续动画直至消失
    return NO;
}
- (void)danmakuViewPerpareComplete:(DanmakuView *)danmakuView {
    // 弹幕初始化完成
    NSLog(@"弹幕初始化完成");
    [_danmukuView start];
}

/** 接收到要跳转到相关界面的通知 */
- (void)pushAboutVideos {
    
    [self.mainPlayer pause];
    [self.danmukuView stop];
    
    if ([self.palyerBtn.titleLabel.text isEqualToString:@"暂停"]) {
        [self.palyerBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.hiddenControlViewAfter invalidate];
    NSLog(@"will");
}

- (void)dealloc {
    NSLog(@"dealloc");
    
    // 移除观察者
    [self removeObserver:self.currentItem];
    
//    [self.mainPlayer.currentItem cancelPendingSeeks];
//    [self.mainPlayer.currentItem.asset cancelLoading];
}
#pragma mark - 收藏

///** 判断是否收藏过，添加收藏按钮 */
//- (void)whetherCollection
//{
//    
//    
//    // 添加收藏按钮
//    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection_action"] style:UIBarButtonItemStylePlain target:self action:@selector(collectionArticle)];
//    self.navigationItem.rightBarButtonItem = collectionItem;
//    
//    
//    //    if (/** 未收藏 */) {  // 未收藏
//    //
//    //        // 添加收藏按钮
//    //        UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection_action"] style:UIBarButtonItemStylePlain target:self action:@selector(collectionArticle)];
//    //        self.navigationItem.rightBarButtonItem = collectionItem;
//    //    } else {  // 已收藏
//    //
//    //        // 添加已收藏按钮
//    //        UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection_did"] style:UIBarButtonItemStylePlain target:self action:@selector(didCollection)];
//    //        self.navigationItem.rightBarButtonItem = collectionItem;
//    //    }
//    
//    
//    
//}
//
//
///** 收藏文章 */
//- (void)collectionArticle
//{
//    
//    NSLog(@"收藏视频");
//    
//    
//}
///** 提示已收藏 */
//- (void)didCollection {
//    
//    
//    NSLog(@"已经收藏过了");
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"****%@",[segue.destinationViewController class]);
}
*/

@end
