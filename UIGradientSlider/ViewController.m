//
//  ViewController.m
//  UIGradientSlider
//
//  Created by Vasily Popov on 6/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.actionBlock = ^(UIGradientSlider* slider, CGFloat value, BOOL endTracking) {
        [CATransaction begin];
        [CATransaction setValue:@YES forKey: kCATransactionDisableActions];
        slider.thumbColor = slider.valueColor;
        [CATransaction commit];
    };
    self.slider.thumbColor = self.slider.valueColor;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
