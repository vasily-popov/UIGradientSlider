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
    self.slider.actionBlock = ^(UIGradientSlider* slider, CGFloat value) {
        [CATransaction begin];
        [CATransaction setValue:@YES forKey: kCATransactionDisableActions];
        CGFloat diff = slider.maxValue - slider.minValue;
        slider.thumbColor = [UIColor colorWithHue:value/diff saturation:1.0 brightness:1.0 alpha:1.0];
        [CATransaction commit];
    };
    self.slider.thumbColor = [UIColor colorWithHue:127.0/255.0 saturation:1.0 brightness:1.0 alpha:1.0];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
