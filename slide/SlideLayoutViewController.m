//
//  SlideLayoutViewController.m
//  LRLayoutDemo
//
//  Created by LiYeBiao on 15/4/14.
//  Copyright (c) 2015年 GaoJing Electric Co., Ltd. All rights reserved.
//

#import "SlideLayoutViewController.h"
#import "UIImage+Blur.h"

#define Slide_iScreenWidth [UIScreen mainScreen].bounds.size.width
#define Slide_iScreenHeight [UIScreen mainScreen].bounds.size.height

#define MaxWidthScale 0.15

#define DValue 0.216

#define MinScale (1-DValue)


//bgImage 滚动方向 -1:从左向右  1:从右向左
#define BgScrollDirection -1

typedef enum : NSInteger {
    kMoveDirectionNone,
    kMoveDirectionUp,
    kMoveDirectionDown,
    kMoveDirectionRight,
    kMoveDirectionLeft
} MoveDirection ;



@interface SlideLayoutViewController ()

@property (nonatomic,strong) SlideMenuViewController * menuViewController;
@property (nonatomic,strong) UIViewController * contentViewController;

@property (nonatomic,assign) MoveDirection direction;
@property (nonatomic,assign) CGFloat prevMoveX;

@property (nonatomic,strong) UITapGestureRecognizer * tapGes;
@property (nonatomic,strong) UIPanGestureRecognizer * panGes;

@property (nonatomic,strong) UIImageView * bgImageView;
@property (nonatomic,strong) UIScrollView * bgScrollView;
@property (nonatomic,strong) UIImageView * bgBlurImageView;


@end

@implementation SlideLayoutViewController

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(SlideMenuViewController *)menuViewController{
    self = [super init];
    if (self) {
        self.menuViewController = menuViewController;
        self.contentViewController = contentViewController;
        [self initData];
        [self initComponent];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    __weak SlideLayoutViewController * _weak_self = self;
    _menuViewController.menuClickBlock = ^(UIViewController * controller){
        [_weak_self openWithController:controller];
    };
}

- (void)openWithController:(UIViewController *)controller{
    if ([_contentViewController respondsToSelector:@selector(openWithController:)]) {
        [_contentViewController performSelector:@selector(openWithController:) withObject:controller];
        [self close];
    }else{
        NSLog(@"Error: *** no found method openWithController: ***");
    }
}

- (void)setBgImage:(UIImage *)image{
    _bgImageView.image = image;
//    _bgBlurImageView.image = image;
    
    float quality = .00001f;
    float blurred = .2f;
    
    NSData *imageData = UIImageJPEGRepresentation(image, quality);
    UIImage *blurredImage = [[UIImage imageWithData:imageData] blurredImage:blurred];
    _bgBlurImageView.image = blurredImage;
}

- (void)initComponent{
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Slide_iScreenWidth, Slide_iScreenHeight)];
    _bgScrollView.contentSize = CGSizeMake(Slide_iScreenWidth*2, Slide_iScreenHeight);
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Slide_iScreenWidth*2, Slide_iScreenHeight)];
    _bgImageView.backgroundColor = [UIColor clearColor];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgScrollView addSubview:_bgImageView];
    
    self.bgBlurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Slide_iScreenWidth*2, Slide_iScreenHeight)];
    _bgBlurImageView.backgroundColor = [UIColor clearColor];
    _bgBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgScrollView addSubview:_bgBlurImageView];
    
    
    
    [self.view addSubview:_menuViewController.view];
    _contentViewController.view.clipsToBounds = YES;
    [self.view addSubview:_contentViewController.view];
    
    self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [self.contentViewController.view addGestureRecognizer:_panGes];
    
    self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self.contentViewController.view addGestureRecognizer:_tapGes];
}

- (void)tapGes:(UIPanGestureRecognizer *)ges{
    [self close];
}

- (void)panGes:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
            CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
            CGFloat cX = [piece center].x + translation.x;
            if(cX < Slide_iScreenWidth/2){
                cX = Slide_iScreenWidth/2;
            }else if(cX >= Slide_iScreenWidth + Slide_iScreenWidth*MaxWidthScale){
                cX = Slide_iScreenWidth + Slide_iScreenWidth*MaxWidthScale;
            }
            
            CGFloat scale = (cX-Slide_iScreenWidth/2)/Slide_iScreenWidth/3;
            
            [self moveMenuWithScale:(MinScale+scale)];
            
            [self moveContentWithScale:(1-scale)];
            [piece setCenter:CGPointMake(cX, Slide_iScreenHeight/2 )];//+ translation.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
            
            CGFloat currentMoveX = CGRectGetMinX(piece.frame);
            if(currentMoveX > _prevMoveX){
                _direction = kMoveDirectionRight;
            }else if(currentMoveX < _prevMoveX){
                _direction = kMoveDirectionLeft;
            }else if(currentMoveX > Slide_iScreenWidth/2){
                _direction = kMoveDirectionRight;
            }else{
                _direction = kMoveDirectionLeft;
            }
            _prevMoveX = currentMoveX;
        }
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        switch (_direction) {
            case kMoveDirectionRight:
            {
                [self open];
            }
                break;
            case kMoveDirectionLeft:
            {
                [self close];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)moveMenuWithScale:(CGFloat)scale{
    if(scale > 1.0f){
        scale = 1.0f;
    }
    CGFloat centerX = Slide_iScreenWidth*scale/2;
    CGPoint mViewCenter = _menuViewController.view.center;
    mViewCenter.x = centerX*(scale)+CGRectGetMinX(_contentViewController.view.frame)*(1-scale);
    NSLog(@"scale: %f    a: %f",scale,_bgBlurImageView.alpha);
    _menuViewController.view.center = mViewCenter;
    _menuViewController.view.transform = CGAffineTransformMakeScale(scale,scale);
}

- (void)moveContentWithScale:(CGFloat)scale{
    
    _contentViewController.view.transform = CGAffineTransformMakeScale(scale,scale);
    _contentViewController.view.layer.cornerRadius = 100*(1-scale);
    
    _bgScrollView.contentOffset = CGPointMake(BgScrollDirection*(Slide_iScreenWidth*2)*(1-scale), 0);
    
    
    
    _bgBlurImageView.alpha = 10*(DValue-(1-scale));
//    NSLog(@"scale: %f    a: %f",scale,_bgBlurImageView.alpha);
}

- (void)open{
    __weak SlideLayoutViewController * _weak_self = self;
    CGFloat scale = (Slide_iScreenWidth+Slide_iScreenWidth*MaxWidthScale-Slide_iScreenWidth/2)/Slide_iScreenWidth/3;
    [UIView animateWithDuration:0.15 animations:^{
        [_weak_self.contentViewController.view setCenter:CGPointMake(Slide_iScreenWidth + Slide_iScreenWidth*MaxWidthScale, Slide_iScreenHeight/2 )];
        [_weak_self moveMenuWithScale:1];
        [_weak_self moveContentWithScale:(1-scale)];
        [_weak_self.contentViewController.view addGestureRecognizer:_weak_self.tapGes];
    }];
}

- (void)close{
    __weak SlideLayoutViewController * _weak_self = self;
    [UIView animateWithDuration:0.15 animations:^{
        [_weak_self.contentViewController.view setCenter:CGPointMake(Slide_iScreenWidth/2, Slide_iScreenHeight/2)];
        [_weak_self moveMenuWithScale:MinScale];
        [_weak_self moveContentWithScale:1];
        [_weak_self.contentViewController.view removeGestureRecognizer:_weak_self.tapGes];

    }];
    
}


@end
