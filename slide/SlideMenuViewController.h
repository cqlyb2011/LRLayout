//
//  SlideMenuViewController.h
//  LRLayoutDemo
//
//  Created by LiYeBiao on 15/4/14.
//  Copyright (c) 2015年 GaoJing Electric Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideMenuDelegate <NSObject>

@required
- (void)openWithController:(UIViewController *)viewController;
- (void)openWithControllerAlias:(NSString *)controllerAlias;
@end


@interface SlideMenuViewController : UIViewController

@property (nonatomic,copy) void (^menuClickBlock)(UIViewController * controller);


@end
