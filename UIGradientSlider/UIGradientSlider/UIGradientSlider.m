//
//  UIGradientSlider.m
//  UIGradientApp
//
//  Created by Vasily Popov on 6/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "UIGradientSlider.h"

#define defaultThickness 2.0f
#define defaultThumbSize 28.0f

@interface UIGradientSlider ()
{
    CGFloat currentValue, _thumbSize;
    CALayer *_thumbLayer;
    CAGradientLayer *_trackLayer;
    CALayer *_thumbIconLayer;
    BOOL continuous;
}

@property (nonatomic, strong, readonly) CALayer *thumbLayer;
@property (nonatomic, strong, readonly) CAGradientLayer *trackLayer;
@property (nonatomic, strong) CALayer *minTrackImageLayer;
@property (nonatomic, strong) CALayer *maxTrackImageLayer;
@property (nonatomic, strong, readonly) CALayer *thumbIconLayer;

@end

@implementation UIGradientSlider

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setDefaultValues];
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setDefaultValues];
        [self setup];
    }
    return self;
}

-(void)setDefaultValues {
    _isRainbow = NO;
    _minValue = 0.0;
    _maxValue = 1.0;
    _minColor = [UIColor blueColor];
    _maxColor = [UIColor orangeColor];
    _thickness = defaultThickness;
    currentValue = 0.0f;
    continuous = YES;
    _thumbSize = defaultThumbSize;
    _thumbBorderWidth = 5.0f;
    _thumbBorderColor = [UIColor whiteColor];
}

-(void)setup {
    self.layer.delegate = self;
    [self.layer addSublayer:self.trackLayer];
    [self.layer addSublayer:self.thumbLayer];
    [self.thumbLayer addSublayer:self.thumbIconLayer];
}

-(CGSize) intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, self.thumbSize);
}


-(UIEdgeInsets) alignmentRectInsets {
    return UIEdgeInsetsMake(4.0, 2.0, 4.0, 2.0);
}

#pragma mark - layer

-(void)layoutSublayersOfLayer:(CALayer *)layer {
    
    //[super layoutSublayersOfLayer:layer];
    
    if(layer != self.layer) {
        return;
    }
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat left = 2.0;
    
    CALayer *minImgLayer = _minTrackImageLayer;
    
    if(minImgLayer != nil)  {
        minImgLayer.position = CGPointMake(0.0, h/2.0);
        left = minImgLayer.bounds.size.width +13.0;
    }
    
    w -= left;
    
    
    
    CALayer *maxImgLayer = _maxTrackImageLayer;
    
    if(maxImgLayer != nil) {
        maxImgLayer.position = CGPointMake(self.bounds.size.width, h/2.0);
        w -= (maxImgLayer.bounds.size.width +13.0);
    }else{
        w -= 2.0;
    }
    
    
    _trackLayer.bounds = CGRectMake(0, 0, w, _thickness);
    _trackLayer.position = CGPointMake( w/2.0 + left, h/2.0);
    
    
    CGFloat halfSize = _thumbSize/2.0;
    CGFloat layerSize = _thumbSize - 4.0;
    
    UIImage *icon = _thumbIcon;
    
    if(icon) {
        layerSize = fmin(fmax(icon.size.height,icon.size.width),layerSize);
        _thumbIconLayer.cornerRadius = 0.0;
        _thumbIconLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    else {
        _thumbIconLayer.cornerRadius = layerSize/2.0;
    }
    
    _thumbIconLayer.position = CGPointMake(halfSize, halfSize);
    _thumbIconLayer.bounds = CGRectMake(0, 0, layerSize, layerSize);
    [self updateThumbPosition:NO];
}

-(void) updateThumbPosition:(BOOL) animated {
    CGFloat diff = _maxValue - _minValue;
    CGFloat perc = (currentValue - _minValue) / diff;
    
    CGFloat halfHeight = self.bounds.size.height / 2.0;
    CGFloat trackWidth = _trackLayer.bounds.size.width - _thumbSize;
    CGFloat left = _trackLayer.position.x - trackWidth/2.0;
    
    if (!animated) {
        [CATransaction begin]; //Move the thumb position without animations
        [CATransaction setValue:@YES forKey: kCATransactionDisableActions];
        _thumbLayer.position = CGPointMake(left + (trackWidth * perc), halfHeight);
        [CATransaction commit];
    } else {
        _thumbLayer.position = CGPointMake(left + (trackWidth * perc), halfHeight);
    }
}

#pragma mark - delegate

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    
    CGPoint center = _thumbLayer.position;
    CGFloat diameter = fmax(_thumbSize,44.0);
    CGRect r = CGRectMake(center.x - diameter/2.0, center.y - diameter/2.0, diameter,  diameter);
    if(CGRectContainsPoint(r, pt)) {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        return YES;
    }
    return NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint pt = [touch locationInView:self];
    CGFloat newValue = [self valueForLocation:pt];
    [self setValue:newValue animated:NO];
    if(continuous){
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        if(self.actionBlock) {
            self.actionBlock(self,newValue, NO);
        }
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if(touch) {
        CGPoint pt = [touch locationInView:self];
        CGFloat newValue = [self valueForLocation:pt];
        [self setValue:newValue animated:NO];
    }
    if(self.actionBlock) {
        self.actionBlock(self,currentValue, YES);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
}


#pragma mark - properties

-(CGFloat)value
{
    return currentValue;
}

-(void)setValue:(CGFloat)value
{
    [self setValue:value animated:YES];
}

-(void)setValue:(CGFloat) value animated:(BOOL) animated {
    currentValue = fmax(fmin(value,self.maxValue),self.minValue);
    [self updateThumbPosition:animated];
}

-(void)setThumbSize:(CGFloat)thumbSize {
    _thumbSize = thumbSize;
    _thumbLayer.cornerRadius = _thumbSize / 2.0;
    _thumbLayer.bounds = CGRectMake(0, 0, _thumbSize, _thumbSize);
    [self invalidateIntrinsicContentSize];
}


-(void)setThickness:(CGFloat)thickness {
    _thickness = thickness;
    _trackLayer.cornerRadius = thickness / 2.0;
    [self.layer setNeedsLayout];
}

-(void)setIsRainbow:(BOOL)isRainbow {
    _isRainbow = isRainbow;
    [self updateTrackColors];
}

-(void)setMinColor:(UIColor *)minColor {
    _minColor = minColor;
    [self updateTrackColors];
}

-(void)setMaxColor:(UIColor *)maxColor {
    _maxColor = maxColor;
    [self updateTrackColors];
}

-(UIColor *)thumbColor
{
    CGColorRef color = _thumbIconLayer.backgroundColor;
    if(color != nil) {
        return [UIColor colorWithCGColor:color];
    }
    return [UIColor whiteColor];
}

-(void)setThumbColor:(UIColor *)thumbColor {
    _thumbIconLayer.backgroundColor = thumbColor.CGColor;
}

-(void)setThumbBorderWidth:(CGFloat)thumbBorderWidth {
    _thumbLayer.borderWidth = thumbBorderWidth;
}

-(void)setThumbBorderColor:(UIColor *)thumbBorderColor {
    _thumbLayer.borderColor = thumbBorderColor.CGColor;
}

-(void)setTrackBorderWidth:(CGFloat)trackBorderWidth {
    _trackLayer.borderWidth = trackBorderWidth;
}

-(void)setTrackBorderColor:(UIColor *)trackBorderColor {
    _trackLayer.borderColor = trackBorderColor.CGColor;
}

-(CALayer*)thumbLayer
{
    if(!_thumbLayer) {
        _thumbLayer = [CALayer new];
        _thumbLayer.cornerRadius = defaultThumbSize/2.0;
        _thumbLayer.bounds = CGRectMake(0, 0, defaultThumbSize, defaultThumbSize);
        _thumbLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _thumbLayer.borderColor = _thumbBorderColor.CGColor;
        _thumbLayer.borderWidth = _thumbBorderWidth;
        
    }
    return _thumbLayer;
}

-(CAGradientLayer*)trackLayer
{
    if(!_trackLayer) {
        _trackLayer = [CAGradientLayer new];
        _trackLayer.cornerRadius = defaultThickness / 2.0;
        _trackLayer.startPoint = CGPointMake(0.0, 0.5);
        _trackLayer.endPoint = CGPointMake(1.0, 0.5);
        _trackLayer.locations = @[@0.0,@1.0];
        _trackLayer.colors = @[(id)[UIColor blueColor].CGColor,(id)[UIColor orangeColor].CGColor];
        _trackLayer.borderColor = [UIColor blackColor].CGColor;
    }
    return _trackLayer;
}

-(CALayer*)thumbIconLayer
{
    
    if(!_thumbIconLayer) {
        CGFloat size = defaultThumbSize - 4;
        _thumbIconLayer = [CALayer new];
        _thumbIconLayer.cornerRadius = size/2.0;
        _thumbIconLayer.bounds = CGRectMake(0, 0, size, size);
        _thumbIconLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _thumbIconLayer;
}

#pragma mark - private

-(CGFloat)valueForLocation:(CGPoint) point {
    CGFloat left = self.bounds.origin.x;
    CGFloat w = self.bounds.size.width;
    
    CALayer *minImgLayer = _minTrackImageLayer;
    if (minImgLayer) {
        CGFloat amt = minImgLayer.bounds.size.width + 13.0;
        w -= amt;
        left += amt;
    } else {
        w -= 2.0;
        left += 2.0;
    }
    
    CALayer *maxImgLayer = _maxTrackImageLayer;
    if (maxImgLayer) {
        w -= (maxImgLayer.bounds.size.width + 13.0);
    }else{
        w -= 2.0;
    }
    
    CGFloat diff = self.maxValue - self.minValue;
    
    CGFloat perc = fmax(fmin((point.x - left) / w ,1.0), 0.0);
    
    return (perc * diff) + self.minValue;
}

-(void)updateTrackColors {
    if(_isRainbow) {
        
        CGFloat h = 0.0;
        CGFloat s = 0.0;
        CGFloat l = 0.0;
        CGFloat a = 1.0;
        
        [_minColor getHue:&h saturation:&s brightness:&l alpha:&a];
        
        CGFloat cnt = 10.0f;
        CGFloat step = 1.0f / cnt;
        
        NSMutableArray *colors = [NSMutableArray new];
        NSMutableArray<NSNumber*> *locations = [NSMutableArray new];
        for (CGFloat f = 0.0; f<cnt; f+=step) {
            [locations addObject:@(step*f)];
            [colors addObject:(id)[UIColor colorWithHue:step*f saturation:s brightness:l alpha:a].CGColor];
        }
        if(colors.count > 0) {
            _trackLayer.colors = [colors copy];
        }
        if(locations.count > 0) {
            _trackLayer.locations = [locations copy];
        }
        
    }
    else {
        _trackLayer.colors = @[(id)_minColor.CGColor, (id)_maxColor.CGColor];
        _trackLayer.locations = @[@0.0,@1.0];
    }
}

-(UIColor *)valueColor
{
    if(_isRainbow){
        CGFloat diff = _maxValue - _minValue;
        if(diff != 0) {
            return  [UIColor colorWithHue:currentValue/diff saturation:1.0 brightness:1.0 alpha:1.0];
        }
    }
    return [UIColor whiteColor];
}


@end
