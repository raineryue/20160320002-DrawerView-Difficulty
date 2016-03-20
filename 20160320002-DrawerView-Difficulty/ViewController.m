//
//  ViewController.m
//  20160320002-DrawerView-Difficulty
//
//  Created by Rainer on 16/3/20.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

// 当前屏幕的高度
#define kScreenH [UIScreen mainScreen].bounds.size.height

// 当前屏幕的宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width

// 定义y轴最大偏移量为80.0
#define kMaxOffsetY 80.0

@interface ViewController ()

@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UIView *mainView;

@end

@implementation ViewController

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
    
    self.leftView = leftView;
    
    [self.view addSubview:self.leftView];
    
    // 2.添加右边视图
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    rightView.backgroundColor = [UIColor blueColor];
    
    self.rightView = rightView;
    
    [self.view addSubview:self.rightView];
    
    // 3.添加主视图
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    mainView.backgroundColor = [UIColor redColor];
    
    self.mainView = mainView;
    
    [self.view addSubview:self.mainView];
}

#pragma mark - 手势操作
/**
 *  添加手势
 */
- (void)setupGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self.view addGestureRecognizer:panGestureRecognizer];
}

/**
 *  拖拽手势事件处理
 */
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 1.获取当前移动的点
    CGPoint movePoint = [panGestureRecognizer translationInView:self.view];
    
    // 2.根据手势移动到的点计算移动后的frame,并设置视图的frame
    self.mainView.frame = [self mainViewFrameWithMovePoint:movePoint];
    
    // 3.将手势移动点复位
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    
    // 4.设置左右视图的显示和隐藏
    [self hidenOrShowOtherViews];
}

/**
 *  根据手势移动到的点计算移动后的frame
 *  手指往右拖动时：x轴增加（x++），y轴增加(y++)，高度宽度按比例缩放
 */
- (CGRect)mainViewFrameWithMovePoint:(CGPoint)movePoint {
    // 1.获取主视图的frame
    CGRect moveMainViewFrame = self.mainView.frame;
    
    // 2.x轴每平移一点，算出y轴需要平移多少
    CGFloat offsetY = movePoint.x * (kMaxOffsetY / kScreenH);
    
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
    moveMainViewFrame.origin.x += movePoint.x;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
