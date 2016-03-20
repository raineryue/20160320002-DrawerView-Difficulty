//
//  ViewController.h
//  20160320002-DrawerView-Difficulty
//
//  Created by Rainer on 16/3/20.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  这里暴露给外面的属性需要使用只读属性
 */
@interface RYDrawerViewController : UIViewController

@property (nonatomic, weak, readonly) UIView *leftView;
@property (nonatomic, weak, readonly) UIView *rightView;
@property (nonatomic, weak, readonly) UIView *mainView;

@end

