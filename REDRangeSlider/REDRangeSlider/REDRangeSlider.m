//
//  REDRangeSlider.m
//
//
//  Created by Red Davis on 24/10/2012.
//  Copyright (c) 2013 Red Davis. All rights reserved.
//

#import "REDRangeSlider.h"

#import <QuartzCore/QuartzCore.h>


@interface REDRangeSlider () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *leftHandle;
@property (strong, nonatomic) UIImageView *rightHandle;
@property (strong, nonatomic) UIImageView *sliderBackground;
@property (strong, nonatomic) UIImageView *sliderFillBackground;

@property (assign, nonatomic) CGFloat leftHandleStartXCoor;
@property (assign, nonatomic) CGFloat rightHandleStartXCoor;

@property (readonly, nonatomic) CGFloat trackWidth;

- (void)setupUI;
- (void)leftHandlePanEngadged:(UIGestureRecognizer *)gesture;
- (void)rightHandlePanEngadged:(UIGestureRecognizer *)gesture;

@end


static CGFloat const kREDHandleTapTargetRadius = 20.0;


@implementation REDRangeSlider

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        self.handleImage = [UIImage imageNamed:@"slider-handle"];
        self.handleHighlightedImage = [UIImage imageNamed:@"slider-handle-highlighted"];
        self.trackBackgroundImage = [[UIImage imageNamed:@"slider-track-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
        self.trackFillImage = [[UIImage imageNamed:@"slider-track-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
        
        [self setupUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    self.handleImage = [UIImage imageNamed:@"slider-handle"];
    self.handleHighlightedImage = [UIImage imageNamed:@"slider-handle-highlighted"];
    self.trackBackgroundImage = [[UIImage imageNamed:@"slider-track-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    self.trackFillImage = [[UIImage imageNamed:@"slider-track-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 5, 4, 5)];
    
    [self setupUI];
}

#pragma mark -

- (void)setLeftValue:(CGFloat)leftValue {
    
    if (leftValue <= self.minValue) {
        _leftValue = self.minValue;
    }
    else if (leftValue >= self.minValue && leftValue <= self.rightValue) {
                
        _leftValue = leftValue;
    }
    
    [self setNeedsLayout];
}

- (void)setRightValue:(CGFloat)rightValue {
    
    if (rightValue >= self.maxValue) {
        _rightValue = self.maxValue;
    }
    else if (rightValue <= self.maxValue && rightValue > self.leftValue) {
                
        _rightValue = rightValue;
    }
    
    [self setNeedsLayout];
}

- (void)setMaxValue:(CGFloat)maxValue {
    
    _maxValue = maxValue;
    [self setNeedsLayout];
}

- (void)setMinValue:(CGFloat)minValue {
    
    _minValue = minValue;
    [self setNeedsLayout];
}

#pragma mark - View Setup

- (void)layoutSubviews {
        
    self.sliderBackground.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.sliderBackground.frame));
    self.sliderBackground.center = CGPointMake(floorf(CGRectGetWidth(self.bounds)/2), floorf(CGRectGetHeight(self.bounds)/2));
    
    // Handles
    CGFloat oneHundredPercent = self.maxValue - self.minValue;
    
    CGFloat leftValuePercentage = self.leftValue/oneHundredPercent;
    CGFloat leftXCoor = floorf((self.trackWidth-self.handleImage.size.width) * leftValuePercentage);
    
    self.leftHandle.frame = CGRectMake(0, 0, CGRectGetWidth(self.leftHandle.frame), CGRectGetHeight(self.leftHandle.frame));
    self.leftHandle.center = CGPointMake(leftXCoor, self.sliderBackground.center.y);
    
    CGFloat rightValuePercentage = self.rightValue/oneHundredPercent;
    CGFloat rightXCoor = floorf((self.trackWidth-self.handleImage.size.width) * rightValuePercentage) + self.handleImage.size.width;
        
    self.rightHandle.frame = CGRectMake(0, 0, CGRectGetWidth(self.rightHandle.frame), CGRectGetHeight(self.rightHandle.frame));
    self.rightHandle.center = CGPointMake(rightXCoor, self.sliderBackground.center.y);
    
    // Fill
    CGFloat fillBackgroundWidth = self.rightHandle.center.x-self.leftHandle.center.x;
    self.sliderFillBackground.frame = CGRectMake(self.leftHandle.center.x, 0, fillBackgroundWidth, CGRectGetHeight(self.sliderFillBackground.frame));
    self.sliderFillBackground.center = CGPointMake(self.sliderFillBackground.center.x, self.sliderBackground.center.y);
}

- (void)setupUI {
    
    if (self.maxValue == 0) {
        self.maxValue = 50.0;
    }
    
    if (self.rightValue == 0) {
        self.rightValue = self.maxValue;
    }
        
    CGRect paddedFrame = self.frame;
    paddedFrame.size.height = kREDHandleTapTargetRadius*2;
    self.frame = paddedFrame;
    
    UIImage *emptySliderImage = self.trackBackgroundImage;
    self.sliderBackground = [[UIImageView alloc] initWithImage:emptySliderImage];

    [self addSubview:self.sliderBackground];

    UIImage *sliderFillImage = self.trackFillImage;
    self.sliderFillBackground = [[UIImageView alloc] initWithImage:sliderFillImage];

    [self addSubview:self.sliderFillBackground];
    
    self.leftHandle = [[UIImageView alloc] init];
    self.leftHandle.image = self.handleImage;
    self.leftHandle.frame = CGRectMake(0, 0, self.handleImage.size.width+kREDHandleTapTargetRadius, self.handleImage.size.height+kREDHandleTapTargetRadius);
    self.leftHandle.contentMode = UIViewContentModeCenter;
    self.leftHandle.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandlePanEngadged:)];
    leftPanGesture.delegate = self;
    [self.leftHandle addGestureRecognizer:leftPanGesture];
    
    [self addSubview:self.leftHandle];
    
    self.rightHandle = [[UIImageView alloc] init];
    self.rightHandle.image = self.handleImage;
    self.rightHandle.frame = CGRectMake(0, 0, self.handleImage.size.width+kREDHandleTapTargetRadius, self.handleImage.size.height+kREDHandleTapTargetRadius);
    self.rightHandle.contentMode = UIViewContentModeCenter;
    self.rightHandle.userInteractionEnabled = YES;
    
    self.leftHandle.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    self.rightHandle.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.3];
    
    UIPanGestureRecognizer *rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandlePanEngadged:)];
    rightPanGesture.delegate = self;
    [self.rightHandle addGestureRecognizer:rightPanGesture];
    
    [self addSubview:self.rightHandle];
}

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *subView in self.subviews) {
        
        UIView *hitView = [subView hitTest:[self convertPoint:point toView:subView] withEvent:event];
        if (hitView) {
            return hitView;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma mark - Gestures

- (void)leftHandlePanEngadged:(UIGestureRecognizer *)gesture {
    
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint pointInView = [panGesture translationInView:self];
        CGFloat oneHundredPercentOfValues = self.maxValue - self.minValue;
        
        CGFloat trackOneHundredPercent = self.trackWidth-self.handleImage.size.width;
        CGFloat trackPercentageChange = (pointInView.x / trackOneHundredPercent)*100;
                        
        self.leftValue += (trackPercentageChange/100.0) * oneHundredPercentOfValues;
        
        [panGesture setTranslation:CGPointZero inView:self];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)rightHandlePanEngadged:(UIGestureRecognizer *)gesture {
    
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint pointInView = [panGesture translationInView:self];
        CGFloat oneHundredPercentOfValues = self.maxValue - self.minValue;
        
        CGFloat trackOneHundredPercent = self.trackWidth-self.handleImage.size.width;
        CGFloat trackPercentageChange = (pointInView.x / trackOneHundredPercent)*100;
        
        self.rightValue += (trackPercentageChange/100.0) * oneHundredPercentOfValues;
        
        [panGesture setTranslation:CGPointZero inView:self];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - 

- (void)setFrame:(CGRect)frame {
    
    frame.size.height = self.handleImage.size.height+kREDHandleTapTargetRadius;
    [super setFrame:frame];
}

#pragma mark - Helpers

- (CGFloat)trackWidth {
    
    return self.frame.size.width;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
