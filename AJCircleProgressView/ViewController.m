//
//  ViewController.m
//  AJCircleProgressView
//
//  Created by Chuan-Jie Jhuang on 2022/4/7.
//

#import "ViewController.h"
#import "AJCircleProgressView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet AJCircleProgressView *circleProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sliderValueChangedAction:(UISlider *)sender {
//    [_circleProgressView animateCircleToEndProgress:sender.value
//                                        andDuration:0.25
//                                     withCompletion:^{
//
//    }];
    _circleProgressView.progress = sender.value;
}

@end
