//
//  RotateAnimator.m
//  ScreenRotate
//
//  Created by mac on 2017/10/19.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "RotateAnimator.h"
#import "Masonry.h"

@implementation RotateAnimator

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = containerView.bounds;
    //    toViewController.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    [containerView addSubview:toViewController.view];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.frame = containerView.bounds;// CGRectMake(0, 0, containerView.frame.size.height, containerView.frame.size.width);
    [containerView addSubview:fromViewController.view];
    
    //播放器视图
    UIView* playView = [fromViewController.view viewWithTag:100];
    
    BOOL isPresent = [fromViewController.presentedViewController isEqual:toViewController];//如果底层的视图弹出的视图是顶层的，那么是present出来的
    
    if (isPresent) {
        [containerView bringSubviewToFront:fromViewController.view];
        
        CGSize size = containerView.frame.size;
        [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
            make.height.equalTo(@(size.height));
            make.center.equalTo(playView.superview);
        }];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [playView.superview layoutIfNeeded];
            playView.transform = CGAffineTransformMakeRotation(M_PI_2);
            toViewController.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            
        } completion:^(BOOL finished) {
            
            [playView removeFromSuperview];
            [toViewController.view addSubview:playView];
            playView.transform = CGAffineTransformMakeRotation(0);
            [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(toViewController.view).insets(UIEdgeInsetsZero);
            }];
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
            
        }];
    }else{
        [containerView bringSubviewToFront:fromViewController.view];
        playView = [fromViewController.view viewWithTag:100];
        
        CGFloat width = containerView.frame.size.width;
        CGFloat height = width * (9 / 16.0f);
        [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(@(width));
            make.height.equalTo(@(height));
            make.center.equalTo(playView.superview).centerOffset(CGPointMake(-(containerView.frame.size.height - height) / 2.0, 0));
        }];
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [playView.superview layoutIfNeeded];
            playView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            
            fromViewController.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
            
        } completion:^(BOOL finished) {
            
            
            [playView removeFromSuperview];
            
            if ([toViewController isKindOfClass:[UINavigationController class]]) {
                UIViewController* vc = ((UINavigationController*)toViewController).viewControllers.lastObject;
                [vc.view addSubview:playView];
            }else{
                [toViewController.view addSubview:playView];
            }
            
            playView.transform = CGAffineTransformMakeRotation(0);
            [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(playView.superview.mas_top).offset(0);
                make.left.equalTo(playView.superview.mas_left).offset(0);
                make.height.mas_equalTo(@(width * (9 / 16.0f)));
                make.right.equalTo(playView.superview.mas_right).offset(0);
            }];
            
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
            
        }];
    }
    
}

@end
