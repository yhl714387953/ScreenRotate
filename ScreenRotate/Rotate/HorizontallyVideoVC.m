//
//  HorizontallyVideoVC.m
//  各种屏幕旋转
//
//  Created by mac on 2017/10/16.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "HorizontallyVideoVC.h"

@interface HorizontallyVideoVC ()

@end

@implementation HorizontallyVideoVC

-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{

    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
}

-(void)dealloc{
    NSLog(@"视屏全屏控制器销毁了");
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
    
    if (device.orientation == UIDeviceOrientationPortrait) {
        
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.didDismiss) {
                weakSelf.didDismiss();
            }
        }];
    }
    
    /*
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     */
    
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
