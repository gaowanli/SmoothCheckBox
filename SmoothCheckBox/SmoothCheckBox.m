//
//  SmoothCheckBox.m
//  SmoothCheckBox
//
//  Created by Broccoli on 16/1/30.
//  Copyright © 2016年 Broccoli. All rights reserved.
//

#import "SmoothCheckBox.h"


CGFloat const DEF_ANIM_DURATION = 0.5;

@interface SmoothCheckBox()

@property (nonatomic, strong) CAShapeLayer *borderCircle;
@property (nonatomic, strong) CAShapeLayer *centerCircle;

@property (nonatomic, assign) BOOL isChecked;

@end

@implementation SmoothCheckBox

#pragma mark -- life circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}

- (instancetype)initWithSideWidth:(CGFloat)sideWidth {
    self = [super initWithFrame:CGRectMake(0, 0, sideWidth, sideWidth)];
    if (self) {
        self.sideWidth = sideWidth;
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI {
    self.backgroundColor = [UIColor whiteColor];
    self.uncheckedFillColor = [UIColor whiteColor];
    self.tickColor = [UIColor whiteColor];
    self.uncheckedLineWidth = 8;
    self.isChecked = false;
    self.uncheckedBorderColor = [UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1];
    [self addTapGestureRecognizer];
    [self addSubLayer];
}

#pragma mark --
- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkBoxClicked)];
    [self addGestureRecognizer:tap];
}

- (void)addSubLayer {
    [self.layer addSublayer:self.borderCircle];
    [self.layer addSublayer:self.centerCircle];
}

#pragma mark -- Action
- (void)checkBoxClicked {
    [self startBorderLayerAnimation];
    [self startScaleBorderLayerAnimaiton];
}

#pragma mark -- animation
// border 基础动画
- (void)startBorderLayerAnimation {
    
    if (self.isChecked) {
        for (CALayer *subLayer in self.borderCircle.sublayers) {
            [subLayer removeFromSuperlayer];
        }
        
        CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        lineWidthAnimation.fromValue = (__bridge id _Nullable)([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sideWidth / 2, self.sideWidth / 2) radius:0.1 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath);
        lineWidthAnimation.toValue = (__bridge id _Nullable)([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sideWidth / 2, self.sideWidth / 2) radius:self.sideWidth / 2 - self.uncheckedLineWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath);
        lineWidthAnimation.duration = DEF_ANIM_DURATION / 3 * 2;
        lineWidthAnimation.removedOnCompletion = NO;
        lineWidthAnimation.fillMode = kCAFillModeForwards;
        [self.centerCircle addAnimation:lineWidthAnimation forKey:nil];
    } else {
        CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        lineWidthAnimation.fromValue = (__bridge id _Nullable)([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sideWidth / 2, self.sideWidth / 2) radius:self.sideWidth / 2 - self.uncheckedLineWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath);
        lineWidthAnimation.toValue = (__bridge id _Nullable)([UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sideWidth / 2, self.sideWidth / 2) radius:0.1 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath);
        lineWidthAnimation.duration = DEF_ANIM_DURATION / 3 * 2;
        lineWidthAnimation.removedOnCompletion = NO;
        lineWidthAnimation.fillMode = kCAFillModeForwards;
        [self.centerCircle addAnimation:lineWidthAnimation forKey:nil];
    }
    
    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    if (self.isChecked) {
        fillColorAnimation.toValue = (__bridge id _Nullable)(self.uncheckedBorderColor.CGColor);
    } else {
        fillColorAnimation.toValue = (__bridge id _Nullable)(self.checkedFillColor.CGColor);
    }
    
    fillColorAnimation.duration = DEF_ANIM_DURATION / 3 * 2;
    fillColorAnimation.removedOnCompletion = NO;
    fillColorAnimation.fillMode = kCAFillModeForwards;
    [self.borderCircle addAnimation:fillColorAnimation forKey:nil];
}

// 缩放动画
- (void)startScaleBorderLayerAnimaiton {
    CABasicAnimation *firstScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D byValue = CATransform3DIdentity;
    byValue = CATransform3DTranslate(byValue, self.bounds.size.width/2, self.bounds.size.height/2, 0);
    byValue = CATransform3DScale(byValue, 0.8, 0.8, 1);
    byValue = CATransform3DTranslate(byValue, -self.bounds.size.width/2, -self.bounds.size.height/2, 0);
    firstScaleAnimation.toValue = [NSValue valueWithCATransform3D:byValue];
    
    firstScaleAnimation.duration = DEF_ANIM_DURATION / 2;
    firstScaleAnimation.removedOnCompletion = NO;
    firstScaleAnimation.fillMode = kCAFillModeForwards;
    
    
    CABasicAnimation *secondScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D toValue = CATransform3DIdentity;
    toValue = CATransform3DTranslate(toValue, self.bounds.size.width/2, self.bounds.size.height/2, 0);
    toValue = CATransform3DScale(toValue, 1, 1, 1);
    toValue = CATransform3DTranslate(toValue, -self.bounds.size.width/2, -self.bounds.size.height/2, 0);
    secondScaleAnimation.toValue = [NSValue valueWithCATransform3D:toValue];
    
    secondScaleAnimation.beginTime = DEF_ANIM_DURATION / 2;
    secondScaleAnimation.duration = DEF_ANIM_DURATION / 2;
    secondScaleAnimation.removedOnCompletion = NO;
    secondScaleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *scaleAnimationGroup = [CAAnimationGroup animation];
    scaleAnimationGroup.animations = @[firstScaleAnimation, secondScaleAnimation];
    scaleAnimationGroup.duration = DEF_ANIM_DURATION;
    [self.borderCircle addAnimation:scaleAnimationGroup forKey:nil];
    [self.centerCircle addAnimation:scaleAnimationGroup forKey:nil];
    
    if (!self.isChecked) {
        self.isChecked = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            if (_style == CheckBoxStyleTick) {
                [self startDrawTick];
            }else if (_style == CheckBoxStyleClose) {
                [self startDrawClose];
            }
        });
    } else {
        self.isChecked = NO;
    }
}

// 打勾勾
- (void)startDrawTick {
    CGFloat unitLength = self.sideWidth / 30;
    CGPoint beginPoint = CGPointMake(unitLength * 7, unitLength * 14);
    CGPoint transitionPoint = CGPointMake(unitLength * 13, unitLength * 20);
    CGPoint endPoint = CGPointMake(unitLength * 22, unitLength * 10);
    
    UIBezierPath *tickPath = [[UIBezierPath alloc] init];
    [tickPath moveToPoint:beginPoint];
    [tickPath addLineToPoint:transitionPoint];
    [tickPath addLineToPoint:endPoint];
    
    CAShapeLayer *tickLayer = [CAShapeLayer layer];
    tickLayer.path = tickPath.CGPath;
    tickLayer.lineWidth = 5;
    tickLayer.lineCap = kCALineCapRound;
    tickLayer.lineJoin = kCALineJoinRound;
    tickLayer.fillColor = [UIColor clearColor].CGColor;
    tickLayer.strokeColor = self.tickColor.CGColor;
    tickLayer.strokeEnd = 0.0;
    [self.borderCircle addSublayer:tickLayer];
    
    CABasicAnimation *drawTickAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawTickAnimation.toValue = @(1.0);
    drawTickAnimation.duration = DEF_ANIM_DURATION;
    drawTickAnimation.removedOnCompletion = NO;
    drawTickAnimation.fillMode = kCAFillModeForwards;
    [tickLayer addAnimation:drawTickAnimation forKey:nil];
}

// 打叉叉
- (void)startDrawClose {
    CGFloat datumPoint = self.sideWidth / 3.0;
    CGPoint point_TopLeft = CGPointMake(datumPoint, datumPoint);
    CGPoint point_TopRight = CGPointMake(2 * datumPoint, datumPoint);
    CGPoint point_BottomLeft = CGPointMake(datumPoint, 2 * datumPoint);
    CGPoint point_BottomRight = CGPointMake(2 * datumPoint, 2 * datumPoint);
    
    UIBezierPath *tickPath = [[UIBezierPath alloc] init];
    [tickPath moveToPoint:point_TopLeft];
    [tickPath addLineToPoint:point_BottomRight];
    [tickPath moveToPoint:point_TopRight];
    [tickPath addLineToPoint:point_BottomLeft];
    
    CAShapeLayer *tickLayer = [CAShapeLayer layer];
    tickLayer.path = tickPath.CGPath;
    tickLayer.lineWidth = 5;
    tickLayer.lineCap = kCALineCapRound;
    tickLayer.lineJoin = kCALineJoinRound;
    tickLayer.fillColor = [UIColor clearColor].CGColor;
    tickLayer.strokeColor = self.tickColor.CGColor;
    tickLayer.strokeEnd = 0.0;
    [self.borderCircle addSublayer:tickLayer];
    
    CABasicAnimation *drawTickAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawTickAnimation.toValue = @(1.0);
    drawTickAnimation.duration = DEF_ANIM_DURATION;
    drawTickAnimation.removedOnCompletion = NO;
    drawTickAnimation.fillMode = kCAFillModeForwards;
    [tickLayer addAnimation:drawTickAnimation forKey:nil];
}

#pragma mark -- getter setter
- (CAShapeLayer *)borderCircle {
    if (!_borderCircle) {
        CGPoint centerPoint = CGPointMake(self.sideWidth / 2, self.sideWidth / 2);
        
        UIBezierPath *borderCirclePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:self.sideWidth / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        _borderCircle = [CAShapeLayer layer];
        _borderCircle.path = borderCirclePath.CGPath;
        _borderCircle.fillColor = self.uncheckedBorderColor.CGColor;
    }
    return _borderCircle;
}

- (CAShapeLayer *)centerCircle {
    if (!_centerCircle) {
        CGPoint centerPoint = CGPointMake(self.sideWidth / 2, self.sideWidth / 2);
        
        UIBezierPath *centerCirclePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:self.sideWidth / 2 - self.uncheckedLineWidth startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        _centerCircle = [CAShapeLayer layer];
        _centerCircle.path = centerCirclePath.CGPath;
        _centerCircle.fillColor = self.uncheckedFillColor.CGColor;
    }
    return _centerCircle;
}

- (void)setStyle:(CheckBoxStyle)style {
    _style = style;
    if (_style == CheckBoxStyleTick) {
        self.checkedFillColor = [UIColor colorWithRed:21.0 / 255.0 green:155.0 / 255.0 blue:69.0 / 255.0 alpha:1.0];
    }else if (_style == CheckBoxStyleClose) {
        self.checkedFillColor = [UIColor redColor];
    }
}

@end
