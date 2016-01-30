//
//  ViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/28.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsOfX;
@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (strong,nonatomic)UIView *subView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = kThemeColor;
    
    UIScreenEdgePanGestureRecognizer *edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc]init];
    [edgeGesture addTarget:self action:@selector(displaySideBar:)];
    edgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGesture];
    
//    self.view.frame = CGRectMake(0, 0, kScreenWidth / 2, kScreenHeight);
    
//    self.constraintsOfX.constant = -CGRectGetWidth(self.ContainerView.frame);
//    NSLog(@"%@",self.view.subviews);
    
    self.subView = [[UIView alloc] initWithFrame:self.view.frame];
    self.subView.backgroundColor = kThemeColor;
    [self.view insertSubview:self.subView belowSubview:self.ContainerView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(sidebarPan:)];
    [self.ContainerView addGestureRecognizer:pan];
    
//    NSLog(@"%@",self.view.gestureRecognizers);
//    NSLog(@"%@",self.subView.gestureRecognizers);
//    NSLog(@"%@",self.ContainerView.gestureRecognizers);
    
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//    self.navigationController.navigationBar;
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navibar_iamge"] forBarMetrics:UIBarMetricsDefault];
}

- (void)displaySideBar:(UIScreenEdgePanGestureRecognizer *)gesture {
    NSLog(@"aaa");
    
    CGFloat width = CGRectGetWidth(self.ContainerView.frame);
    
    CGPoint point = [gesture translationInView:gesture.view];
//    NSLog(@"%f",point.x);
    
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible: {
            
            break;
        }
        case UIGestureRecognizerStateBegan: {
            NSLog(@"began");
            break;
        }
        case UIGestureRecognizerStateChanged: {
            NSLog(@"changed");
            
            if (point.x > width) {
                self.constraintsOfX.constant = width;
                gesture.enabled = NO;
                self.subView.alpha = 0.5;
            } else {
                self.constraintsOfX.constant = point.x;
                self.subView.alpha = 1 - point.x / (width * 2);
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            NSLog(@"ended");
//            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sidebar"];
//            vc.view.frame = CGRectMake(-kScreenWidth / 2, 0, kScreenWidth / 2, kScreenHeight);
//            [self presentViewController:vc animated:YES completion:nil];
            
//            NSLog(@"%@",NSStringFromCGRect(vc.view.frame));
//            self.constraintsOfX.constant = 0;
            if (point.x < width * 2 / 3) {
                self.constraintsOfX.constant = 0;
                self.subView.alpha = 1;
            } else {
                self.constraintsOfX.constant = width;
                gesture.enabled = NO;
                self.ContainerView.gestureRecognizers.firstObject.enabled = YES;
                self.subView.alpha = 0.5;
                
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
    
//    NSLog(@"%@",self.view.subviews);
}

- (void)sidebarPan:(UIPanGestureRecognizer *)pan {
    NSLog(@"cccc");
    CGPoint point = [pan translationInView:self.view];
    CGFloat width = CGRectGetWidth(pan.view.frame);
    NSLog(@"%@",NSStringFromCGPoint(point));
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:{
            self.constraintsOfX.constant = point.x + width;
            self.subView.alpha = 1 - point.x / (width * 2);
            break; }
        case UIGestureRecognizerStateEnded:{
            if (point.x < width * 1 / 3) {
                self.constraintsOfX.constant = 0;
                self.subView.alpha = 1;
                pan.enabled = NO;
                self.view.gestureRecognizers.firstObject.enabled = YES;
            } else {
                self.constraintsOfX.constant = width;
                self.subView.alpha = 0.5;
            }
            break;}
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
