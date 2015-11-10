//
//  ViewController.m
//  LLProgressView
//
//  Created by levy on 15/11/10.
//  Copyright © 2015年 levy. All rights reserved.
//

#import "ViewController.h"
#import "LLProgressView.h"

@interface ViewController ()
{
    CGFloat progress;
}
@property (strong, nonatomic) IBOutlet LLProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView.fromColor = [UIColor colorWithRed:0.06 green:0.9214 blue:0.6161 alpha:1.0];
    self.progressView.toColor = [UIColor colorWithRed:0.9805 green:0.0751 blue:0.3216 alpha:1.0];
    self.progressView.borderWidth = 0.0;
    self.progressView.lineWidth = 10;
    self.progressView.userInteractionEnabled = NO;
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test1"]];
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(_progressView.frame)-10, CGRectGetWidth(_progressView.frame)-10);
    imageView.center = CGPointMake(CGRectGetWidth(_progressView.frame)/2.0, CGRectGetWidth(_progressView.frame)/2.0);
    self.progressView.centralView = imageView;
    
    self.progressView.progressChangedBlock = ^(LLProgressView *progressView, CGFloat progress) {
        //		[(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    };
    
    progress = 0.0;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(id)sender {
    progress += 0.2;
    if (progress > 1.0) {
        progress = progress - 1.0;
        [self.progressView setProgress:0.0 animated:NO];
        [self.progressView setProgress:progress animated:YES];
    }else{
       [self.progressView setProgress:progress animated:YES];
    }
   
    
}

@end
