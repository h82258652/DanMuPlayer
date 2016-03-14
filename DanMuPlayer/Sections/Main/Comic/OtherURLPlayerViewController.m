//
//  OtherURLPlayerViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/12.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "OtherURLPlayerViewController.h"
#import <WebKit/WebKit.h>

@interface OtherURLPlayerViewController ()

@property (nonatomic,strong)WKWebView *mainWKWebView;  // 主网页
@property (weak, nonatomic) IBOutlet UIView *superViewOfWKView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;  // 进度条

@end

@implementation OtherURLPlayerViewController

- (void)loadView {
    [super loadView];
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@",self.mainURLStr);
    
}
/** 加载网页 */
- (void)addWebViewWithURLStr:(NSString *)str {
    
    self.mainURLStr = str;
//    NSLog(@"%@  %@",self.mainURLStr,str);
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc]init];
    self.mainWKWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66) configuration:conf];
    [self.superViewOfWKView addSubview:self.mainWKWebView];
    
    
    [self.mainWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mainURLStr]]];
    self.mainWKWebView.allowsBackForwardNavigationGestures = YES;
    
    [self.mainWKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = [change[NSKeyValueChangeNewKey] doubleValue];
    }
    
}
- (IBAction)backBeforePage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    
    [self.mainWKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
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
