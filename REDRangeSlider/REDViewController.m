//
//  REDViewController.m
//  REDRangeSlider
//
//  Created by Red Davis on 06/02/2013.
//  Copyright (c) 2013 Red Davis. All rights reserved.
//

#import "REDViewController.h"
#import "REDRangeSlider.h"


@interface REDViewController ()

@property (strong, nonatomic) REDRangeSlider *rangeSlider;

- (void)updateSliderLabels;
- (void)rangeSliderValueChanged:(id)sender;

@end


@implementation REDViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.rangeSlider = [[REDRangeSlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.rangeSlider.center = self.view.center;
    [self.rangeSlider addTarget:self action:@selector(rangeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.rangeSlider.minValue = 0.0;
    self.rangeSlider.maxValue = 20.0;
    
    [self.view addSubview:self.rangeSlider];
    [self updateSliderLabels];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)rangeSliderValueChanged:(id)sender {
    
    switch (self.restrictionSegmentedControl.selectedSegmentIndex) {
        case 1:
            self.rangeSlider.leftValue = roundf(self.rangeSlider.leftValue);
            self.rangeSlider.rightValue = roundf(self.rangeSlider.rightValue);
            break;
        case 2:
            self.rangeSlider.rightValue = self.rangeSlider.maxValue - self.rangeSlider.minValue - self.rangeSlider.leftValue;
            break;
    }
    
    [self updateSliderLabels];
}

- (void)segmentedControlChanged:(id)sender {
    [self rangeSliderValueChanged:sender];
}


#pragma mark -

- (void)updateSliderLabels {
    
    self.leftValueLabel.text = [NSString stringWithFormat:@"%.2f", self.rangeSlider.leftValue];
    self.rightValueLabel.text = [NSString stringWithFormat:@"%.2f", self.rangeSlider.rightValue];
}

@end
