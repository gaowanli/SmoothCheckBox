//
//  SmoothCheckBox.h
//  SmoothCheckBox
//
//  Created by Broccoli on 16/1/30.
//  Copyright © 2016年 Broccoli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CheckBoxStyle) {
    CheckBoxStyleTick = 999,
    CheckBoxStyleClose
};

@interface SmoothCheckBox : UIView
// 边长
@property (nonatomic, assign) CGFloat sideWidth;
// 未选择时 边宽
@property (nonatomic, assign) CGFloat uncheckedLineWidth;
// 勾勾的颜色
@property (nonatomic, strong) UIColor *tickColor;
// 选中时 填充色
@property (nonatomic, strong) UIColor *checkedFillColor;
// 未选中时 填充色
@property (nonatomic, strong) UIColor *uncheckedFillColor;
// 未选中时 边框色
@property (nonatomic, strong) UIColor *uncheckedBorderColor;
// 只读属性
@property (nonatomic, assign, readonly) BOOL isChecked;

@property (nonatomic, assign) CheckBoxStyle style;

- (instancetype)initWithSideWidth:(CGFloat)sideWidth;

@end
