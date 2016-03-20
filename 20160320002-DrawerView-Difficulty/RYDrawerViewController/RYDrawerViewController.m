//
//  ViewController.m
//  20160320002-DrawerView-Difficulty
//
//  Created by Rainer on 16/3/20.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "RYDrawerViewController.h"

// 当前屏幕的高度
#define kScreenH [UIScreen mainScreen].bounds.size.height

// 当前屏幕的宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width

// 定义y轴最大偏移量为100.0
#define kMaxOffsetY 100.0

// 定义一个宽度作为主视图拖动后最后可见的大小
#define kRightX 275
#define kLeftX -200

@interface RYDrawerViewController ()



@end

@implementation RYDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加子视图
    [self setupSubviews];
    
    // 2.添加手势
    [self setupGestureRecognizer];
}

#pragma mark - 添加子视图
/**
 *  添加子视图
 */
- (void)setupSubviews {
    // 1.添加左边视图
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    leftView.backgroundColor = [UIColor greenColor];
    
    _leftView = leftView;
    
    [self.view addSubview:self.leftView];
    
    // 2.添加右边视图
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    rightView.backgroundColor = [UIColor blueColor];
    
    _rightView = rightView;
    
    [self.view addSubview:self.rightView];
    
    // 3.添加主视图
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    mainView.backgroundColor = [UIColor redColor];
    
    _mainView = mainView;
    
    [self.view addSubview:self.mainView];
}

#pragma mark - 手势操作
/**
 *  添加手势
 */
- (void)setupGestureRecognizer {
    // 1.添加拖拽手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    // 2.添加轻拍手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

/**
 *  拖拽手势事件处理
 */
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 1.获取当前移动的点
    CGPoint movePoint = [panGestureRecognizer translationInView:self.view];
    
    // 2.根据手势移动到的点计算移动后的frame,并设置视图的frame
    self.mainView.frame = [self mainViewFrameWithOffsetX:movePoint.x];
    
    // 3.将手势移动点复位
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    // 4.设置左右视图的显示和隐藏
    [self hidenOrShowOtherViews];
    
    // 5.当手势结束以后自动定位主视图的位置
    [self changeMainViewFrameWithGestureRecognizer:panGestureRecognizer];
}

/**
 *  轻拍手势事件处理
 */
- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    // 判断主视图的x值是否移动过，如果没有移动则恢复原来的位置
    if (self.mainView.frame.origin.x != 0) {
        // 1.获取当前手指在控制器视图上移动的点
        CGPoint currentPoint = [tapGestureRecognizer locationInView:self.view];
        
        NSLog(@"%@", NSStringFromCGRect(self.mainView.frame));
        
        // 2.判断该点是否在主视图上，如果在则恢复到原来的位置
        if ([self.mainView  pointInside:currentPoint withEvent:nil] == YES) {
            [UIView animateWithDuration:0.25 animations:^{
                self.mainView.frame = self.view.bounds;
            }];
        }
    }
}

/**
 *  根据手势移动到的点计算移动后的frame
 *  手指往右拖动时：x轴增加（x++），y轴增加(y++)，高度宽度按比例缩放
 */
- (CGRect)mainViewFrameWithOffsetX:(CGFloat)offsetX {
    // 1.获取主视图的frame
    CGRect moveMainViewFrame = self.mainView.frame;
    
    // 2.x轴每平移一点，算出y轴需要平移多少
    CGFloat offsetY = offsetX * kMaxOffsetY / kScreenW;
    
    // 3.获取上一次的高度和当前的高度
    CGFloat proviusH = moveMainViewFrame.size.height;
    CGFloat currentH = proviusH - offsetY * 2;

    // 向左滑动时
    if (moveMainViewFrame.origin.x < 0) {
        currentH = proviusH + offsetY * 2;
    }
    
    // 4.根据当前高度和上一次的高度算出缩放比例
    CGFloat scale = currentH / proviusH;
    
    // 5.根据上一次的宽度和缩放比例算出当前宽度
    CGFloat currentW = moveMainViewFrame.size.width * scale;
    
    // 6.算出当前的y值
    CGFloat currentY = (kScreenH - currentH) * 0.5;

    // 7.赋值拖动后的主视图的frame
    moveMainViewFrame.origin.x += offsetX;
    moveMainViewFrame.origin.y = currentY;
    moveMainViewFrame.size.height = currentH;
    moveMainViewFrame.size.width = currentW;
    
    // 8.返回移动好的frame
    return moveMainViewFrame;
}

/**
 *  设置左右视图的显示和隐藏
 */
- (void)hidenOrShowOtherViews {
    if (self.mainView.frame.origin.x > 0) {
        self.rightView.hidden = YES;
    } else if (self.mainView.frame.origin.x < 0) {
        self.rightView.hidden = NO;
    }
}

/**
 *  当手势结束以后自动定位主视图的位置
 */
- (void)changeMainViewFrameWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 当手势结束以后执行以下操作
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 1.定义一个定位后的x的值
        CGFloat tagetX = 0;
        
        // 2.如果当前主视图的x值大于或等于屏幕宽度一般时就设置停在右边的x的值
        if (self.mainView.frame.origin.x >= kScreenW * 0.5) {
            tagetX = kRightX;
        } else if (CGRectGetMaxX(self.mainView.frame) < kScreenW * 0.5) {// 2.如果当前主视图的x值小于屏幕宽度一般时就设置停在左边的x的值
            tagetX = kLeftX;
        }
        
        // 3.算出主视图的偏移量
        CGFloat offsetX = tagetX - self.mainView.frame.origin.x;
        
        // 4.设置主视图的x值，并添加动画
        [UIView animateWithDuration:0.25 animations:^{
            self.mainView.frame = tagetX == 0 ? self.view.bounds : [self mainViewFrameWithOffsetX:offsetX];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
