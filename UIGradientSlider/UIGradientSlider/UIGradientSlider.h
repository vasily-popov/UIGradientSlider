//
//  UIGradientSlider.h
//  UIGradientApp
//
//  Created by Vasily Popov on 6/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface UIGradientSlider : UIControl

@property (nonatomic) IBInspectable BOOL isRainbow;
@property (nonatomic) IBInspectable CGFloat minValue;
@property (nonatomic) IBInspectable CGFloat maxValue;
@property (nonatomic, strong) IBInspectable UIColor *minColor;
@property (nonatomic, strong) IBInspectable UIColor *maxColor;
@property (nonatomic) IBInspectable CGFloat value;
@property (nonatomic, strong) IBInspectable UIImage *minValueImage;
@property (nonatomic, strong) IBInspectable UIImage *maxValueImage;
@property (nonatomic) IBInspectable CGFloat thickness;
@property (nonatomic, strong) IBInspectable UIImage *thumbIcon;
@property (nonatomic, strong, getter=thumbColor) IBInspectable UIColor *thumbColor;

@property (nonatomic, copy) void (^actionBlock)(UIGradientSlider *slider,CGFloat newValue);

@end
