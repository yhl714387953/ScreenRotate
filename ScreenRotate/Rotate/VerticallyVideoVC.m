//
//  VerticallyVideoVC.m
//  各种屏幕旋转
//
//  Created by mac on 2017/10/16.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "VerticallyVideoVC.h"
#import "HorizontallyVideoVC.h"
#import "RotateAnimator.h"
#import "Masonry.h"

@interface VerticallyVideoVC ()

/** <#description#> */
@property (nonatomic, strong) RotateAnimator* customAnimator;

@property (strong, nonatomic) UIView *playView;

/** <#description#> */
@property (nonatomic, strong) UIButton* backButton;

@property (nonatomic, strong) UIButton* fullScreenButton;


@end

@implementation VerticallyVideoVC

-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.playView];
    [self.playView addSubview:self.backButton];
    [self.playView addSubview:self.fullScreenButton];
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(self.playView.mas_width).multipliedBy(9 / 16.0f);
    }];

    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playView.mas_left).offset(15);
        make.top.equalTo(self.playView.mas_top).offset(25);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@30);
    }];
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playView.mas_right).offset(-5);
        make.bottom.equalTo(self.playView.mas_bottom).offset(-5);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@30);
    }];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height - 150, 200, 100)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
    [self.view bringSubviewToFront:self.playView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)dealloc{
    NSLog(@"视屏小屏控制器销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - method
-(void)screenRotate:(NSNotification*)notification{
    
    UIDevice* device = notification.object;
    NSLog(@"notification:::%@", @(device.orientation));
    
    if (device.orientation == UIDeviceOrientationLandscapeLeft) {
        [self jumpToHVideo];
    }
    
    /*
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     */
    
}

-(void)back{
    if ([[self.fullScreenButton titleForState:(UIControlStateNormal)] isEqualToString:@"小屏"]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"dismissViewController执行完毕，有的时候控制器切换如果有视频在播放可能会有顿，可在执行前和完成之后做一些暂停开始的处理");
        }];
        [self.fullScreenButton setTitle:@"全屏" forState:(UIControlStateNormal)];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)fullScreen{
    
    if ([[self.fullScreenButton titleForState:(UIControlStateNormal)] isEqualToString:@"小屏"]) {

        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        [self.fullScreenButton setTitle:@"全屏" forState:(UIControlStateNormal)];
    }else{

        [self jumpToHVideo];
    }
    
}

-(void)jumpToHVideo{
    HorizontallyVideoVC* horizontallyVideoVC = [[HorizontallyVideoVC alloc] init];
    horizontallyVideoVC.transitioningDelegate = self.customAnimator;
    horizontallyVideoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:horizontallyVideoVC animated:YES completion:^{
        NSLog(@"presentViewController执行完毕，有的时候控制器切换如果有视频在播放可能会有顿，可在执行前和完成之后做一些暂停开始的处理");
    }];
    
    __weak typeof(self) weakSelf = self;
    horizontallyVideoVC.didDismiss = ^(){
        [weakSelf.fullScreenButton setTitle:@"全屏" forState:(UIControlStateNormal)];
    };
    
    [weakSelf.fullScreenButton setTitle:@"小屏" forState:(UIControlStateNormal)];
}

#pragma mark -
#pragma mark - getter
-(UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc] initWithFrame:CGRectZero];
        _playView.backgroundColor = [UIColor purpleColor];
        _playView.tag = 100;
    }
    
    return _playView;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [self buttonWithTitle:@"返回" selName:@"back"];
    }
    
    return _backButton;
}

-(UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [self buttonWithTitle:@"全屏" selName:@"fullScreen"];
    }
    
    return _fullScreenButton;
}

-(UIButton*)buttonWithTitle:(NSString*)title selName:(NSString*)selName{
    UIButton* button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:title forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button addTarget:self action:NSSelectorFromString(selName) forControlEvents:(UIControlEventTouchUpInside)];
    
    return button;
}

- (RotateAnimator *)customAnimator
{
    if (!_customAnimator) {
        _customAnimator = [[RotateAnimator alloc] init];
    }
    return _customAnimator;
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
