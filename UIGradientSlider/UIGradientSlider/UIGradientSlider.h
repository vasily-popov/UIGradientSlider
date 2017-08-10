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
@property (nonatomic) IBInspectable CGFloat thumbSize;
@property (nonatomic, strong, getter=thumbColor) IBInspectable UIColor *thumbColor;
@property (nonatomic, strong, getter=valueColor) UIColor *valueColor;

@property (nonatomic, strong) IBInspectable UIColor *thumbBorderColor;
@property (nonatomic) IBInspectable CGFloat thumbBorderWidth;
@property (nonatomic) IBInspectable CGFloat trackBorderWidth;
@property (nonatomic, strong) IBInspectable UIColor *trackBorderColor;


@property (nonatomic, copy) void (^actionBlock)(UIGradientSlider *slider,CGFloat newValue, BOOL endTracking);

@end
