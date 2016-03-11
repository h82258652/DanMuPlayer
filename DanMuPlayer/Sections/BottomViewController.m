//
//  BottomViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/24.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "BottomViewController.h"
#import "RootViewController.h"
#import "SideBarTableViewController.h"
#import "DataHelper.h"

@interface BottomViewController ()

@property (nonatomic,strong)RootViewController *rootVC;  // 主视图
@property (nonatomic,strong)SideBarTableViewController *sideVC;  // 侧边栏
@property (nonatomic,strong)UINavigationController *rootNC;  // 主视图导航栏
@property (nonatomic,strong)UIView *aboveView; // 上层视图 调节透明度


@end

@implementation BottomViewController

- (void)loadView {
    [super loadView];
    self.rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootvc"];
    self.sideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sidebar"];
    
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self.rootVC];
    navi.navigationBar.translucent = NO;
    [navi.navigationBar setBackgroundImage:[UIImage imageWithColor:kThemeColor size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [navi.navigationBar setShadowImage:[[UIImage alloc]init]];
    [navi.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    self.sideVC.view.frame = CGRectMake(-kScreenWidth * 2 / 3, 0, kScreenWidth * 2 / 3, kScreenHeight);
    
    [self.view addSubview:navi.view];
    
    [self.view addSubview:self.sideVC.view];
    
    
    [self addChildViewController:self.sideVC];
    [self addChildViewController:navi];
    
    // 调节明暗度的视图
    self.aboveView = [[UIView alloc]initWithFrame:self.view.frame];
    self.aboveView.backgroundColor = [UIColor grayColor];
//    [self.rootVC.view addSubview:self.aboveView];
    [self.view addSubview:self.aboveView];
    self.aboveView.hidden = YES;
    self.aboveView.alpha = 0;
    
    [self.view bringSubviewToFront:self.sideVC.view];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",NSHomeDirectory());
    
    // 初始化单例
    [DataHelper sharedHelper];
    
    // 侧边栏出现
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc]init];
    [edgeGesture addTarget:self action:@selector(displaySideBar:)];
    edgeGesture.edges = UIRectEdgeLeft;
    [self.rootVC.view addGestureRecognizer:edgeGesture];
//    [self.rootNC.view addGestureRecognizer:edgeGesture];
    
    [self.rootVC.mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:edgeGesture];
    
    // 侧边栏消失
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(sidebarPan:)];
    [self.view addGestureRecognizer:pan];
    pan.enabled = NO;
    
    // 点击消除侧边栏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSidebar:)];
    [self.aboveView addGestureRecognizer:tap];
    tap.enabled = NO;
}

// 显示侧边栏
- (void)displaySideBar:(UIScreenEdgePanGestureRecognizer *)gesture {
//    NSLog(@"aaa");
    
    self.aboveView.hidden = NO;
    
    CGFloat width = CGRectGetWidth(self.sideVC.view.frame);
    
    CGPoint point = [gesture translationInView:gesture.view];
    //    NSLog(@"%f",point.x);
    
    UIPanGestureRecognizer *pan = self.view.gestureRecognizers.firstObject;
    UITapGestureRecognizer *tap = self.aboveView.gestureRecognizers.firstObject;
    
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible: {
            
            break;
        }
        case UIGestureRecognizerStateBegan: {
//            NSLog(@"began");
            break;
        }
        case UIGestureRecognizerStateChanged: {
//            NSLog(@"changed");
//            NSLog(@"%f",point.x);
            if (point.x > width) {
                [self setXOfSideFrameWithX:width];
                
                
                self.aboveView.alpha = 0.5;
            } else {
                [self setXOfSideFrameWithX:point.x];
                self.aboveView.alpha = point.x / (width * 2);
//                NSLog(@"%f",self.aboveView.alpha);
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
//            NSLog(@"ended");
            if (point.x < width * 2 / 3) {
                [self setXOfSideFrameWithX:0];

                self.aboveView.alpha = 0;
                self.aboveView.hidden = YES;
            } else {
                [self setXOfSideFrameWithX:width];
                
                gesture.enabled = NO;
                pan.enabled = YES;
                tap.enabled = YES;
                
                self.aboveView.alpha = 0.5;
                
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"cancell");
            break;
        }
        case UIGestureRecognizerStateFailed: {
            NSLog(@"failed");
            break;
        }
    }
    
//    NSLog(@"变化");
}

// 侧边栏出现后的轻扫事件
- (void)sidebarPan:(UIPanGestureRecognizer *)pan {
//    NSLog(@"cccc");
    
    UITapGestureRecognizer *tap = self.aboveView.gestureRecognizers.firstObject;
    
    CGPoint point = [pan translationInView:self.view];
    CGFloat width = CGRectGetWidth(self.sideVC.view.frame);
//    NSLog(@"%@",NSStringFromCGPoint(point));
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:{
            
            if (point.x > 0) {
                break;
            }
            [self setXOfSideFrameWithX:point.x + width];
            break; }
        case UIGestureRecognizerStateEnded:{
            if (width + point.x < width * 1 / 3) {
                [self setXOfSideFrameWithX:0];
                pan.enabled = NO;
                tap.enabled = NO;
                self.rootVC.view.gestureRecognizers.firstObject.enabled = YES;
                
                self.rootVC.mainScrollView.scrollEnabled = YES;
                self.aboveView.hidden = YES;
                self.aboveView.alpha = 0;
            } else {
                [self setXOfSideFrameWithX:width];
            }
            break;}
        default:
            break;
    }
    
}
// 点击收起侧边栏
- (void)removeSidebar:(UITapGestureRecognizer *)tap {
    [self setXOfSideFrameWithX:0];
    self.rootVC.view.gestureRecognizers.firstObject.enabled = YES;
    UIPanGestureRecognizer *pan = self.view.gestureRecognizers.firstObject;
    pan.enabled = NO;
    tap.enabled = NO;
    self.aboveView.hidden = YES;
    self.aboveView.alpha = 0;
    self.rootVC.mainScrollView.scrollEnabled = YES;
}

// 设置侧边栏的x值
- (void)setXOfSideFrameWithX:(CGFloat)x {
    CGFloat width = self.sideVC.view.frame.size.width;
    CGRect frame = self.sideVC.view.frame;
    frame.origin.x = x - width;
    self.sideVC.view.frame = frame;
}

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
}
*/

@end
