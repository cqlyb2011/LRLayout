//
//  SlideLayoutViewController.h
//  LRLayoutDemo
//
//  Created by LiYeBiao on 15/4/14.
//  Copyright (c) 2015年 GaoJing Electric Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuViewController.h"

@interface SlideLayoutViewController : UIViewController

- (id)initWithContentViewController:(UIViewController<SlideMenuDelegate> *)contentViewController menuViewController:(SlideMenuViewController *)menuViewController;

- (void)setBgImage:(UIImage *)image;

@end
