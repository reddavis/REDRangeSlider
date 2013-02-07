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
    
    [self.view addSubview:self.rangeSlider];
    [self updateSliderLabels];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)rangeSliderValueChanged:(id)sender {
    
    [self updateSliderLabels];
}

#pragma mark -

- (void)updateSliderLabels {
    
    self.leftValueLabel.text = [NSString stringWithFormat:@"%.2f", self.rangeSlider.leftValue];
    self.rightValueLabel.text = [NSString stringWithFormat:@"%.2f", self.rangeSlider.rightValue];
}

@end
