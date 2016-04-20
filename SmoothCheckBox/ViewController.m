//
//  ViewController.m
//  SmoothCheckBox
//
//  Created by Broccoli on 16/1/30.
//  Copyright © 2016年 Broccoli. All rights reserved.
//

#import "ViewController.h"
#import "SmoothCheckBox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSmoothCheckBox];
}

- (void)addSmoothCheckBox {
    SmoothCheckBox *checkBox1 = [[SmoothCheckBox alloc] initWithSideWidth:100];
    checkBox1.center = self.view.center;
    checkBox1.style = CheckBoxStyleTick;
    [self.view addSubview:checkBox1];
    
    SmoothCheckBox *checkBox2 = [[SmoothCheckBox alloc] initWithSideWidth:100];
    checkBox2.center = CGPointMake(self.view.center.x, self.view.center.y + 120);
    checkBox2.style = CheckBoxStyleClose;
    [self.view addSubview:checkBox2];
}

@end
