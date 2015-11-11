//
//  ViewController.m
//  LLProgressView
//
//  Created by levy on 15/11/10.
//  Copyright © 2015年 levy. All rights reserved.
//

#import "ViewController.h"
#import "LLProgressView.h"
#import "LLCustomTextLayer.h"
@interface ViewController ()
{
    CGFloat progress;
    LLCustomTextLayer *textLayer;
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
    self.progressView.animationDuration = 0.6;
    self.progressView.userInteractionEnabled = NO;
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test1"]];
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(_progressView.frame)-10, CGRectGetWidth(_progressView.frame)-10);
    imageView.center = CGPointMake(CGRectGetWidth(_progressView.frame)/2.0, CGRectGetWidth(_progressView.frame)/2.0);
    self.progressView.centralView = imageView;
    
    progress = 0.0;
    // Do any additional setup after loading the view, typically from a nib.
    
    textLayer = [[LLCustomTextLayer alloc] init];
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.string = @"0";
    textLayer.fontSize = 20;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = CGRectMake(0, (CGRectGetWidth(_progressView.frame)-10)/2.0 - 10.5f, CGRectGetWidth(_progressView.frame)-10, 21);
   // textLayer.backgroundColor = [UIColor colorWithRed:0.2542 green:0.9569 blue:0.9197 alpha:1.0].CGColor;
    
    
    [imageView.layer addSublayer:textLayer];
    
    CATextLayer *labelLayer = [CATextLayer new];
    labelLayer.string = @"安全指数";
    labelLayer.alignmentMode = kCAAlignmentCenter;
    labelLayer.foregroundColor = [UIColor colorWithRed:0.3221 green:0.3221 blue:0.3221 alpha:1.0].CGColor;
    labelLayer.fontSize = 10;
    labelLayer.frame = CGRectMake(0, textLayer.frame.origin.y+25, textLayer.frame.size.width, textLayer.frame.size.height);
    [imageView.layer addSublayer:labelLayer];
    
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
        [textLayer jumpNumberWithDuration:0.0f fromNumber:0 toNumber:progress*100];
    }else{
       [self.progressView setProgress:progress animated:YES];
        [textLayer jumpNumberWithDuration:0.0f fromNumber:(progress-0.2)*100 toNumber:progress*100];
    }
    

    
}

@end
