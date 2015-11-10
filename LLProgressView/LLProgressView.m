//
//  LLProgressView.m
//  LLProgressView
//
//  Created by levy on 15/11/10.
//  Copyright © 2015年 levy. All rights reserved.
//

#import "LLProgressView.h"

NSString * const LLProgressViewProgressAnimationKey = @"LLProgressViewProgressAnimationKey";

@interface LLCircularProgressView : UIView
@property (nonatomic, assign) BOOL clockwise;
- (void)updateProgress:(CGFloat)progress;
- (CAShapeLayer *)shapeLayer;

@end

@interface LLProgressView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) LLCircularProgressView *progressView;
@property (nonatomic, assign) int valueLabelProgressPercentDifference;
@property (nonatomic, strong) NSTimer *valueLabelUpdateTimer;
@property (nonatomic, strong) UIColor *borderColor;
@end


@implementation LLProgressView

@synthesize fromColor = _fromColor;
@synthesize toColor = _toColor;
@synthesize borderColor = _borderColor;
#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedSetup];
    }
    return self;
}

- (void)sharedSetup {
    self.progressView = [[LLCircularProgressView alloc] initWithFrame:self.bounds];
    self.progressView.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressView.clockwise = _clockwise;
    [self addSubview:self.progressView];
    
    [self resetDefaults];
}

- (void)resetDefaults {
    
    self.fillChangedBlock = nil;
    self.didSelectBlock	= nil;
    self.progressChangedBlock = nil;
    self.centralView = nil;
    
    _fillOnTouch = YES;
    _clockwise = YES;
    _progress = 0.0;
    _animationDuration = 0.3f;
    
    self.borderWidth = 1.0f;
    self.lineWidth = 2.0f;
    
    [self setupGestureRecognizer];
    
}

- (void)setupGestureRecognizer {
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchDetected:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.minimumPressDuration = 0.0;
    [self addGestureRecognizer:gestureRecognizer];
}

#pragma mark - Public Accessors


- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.progressView.shapeLayer.borderWidth = borderWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.progressView.shapeLayer.lineWidth = lineWidth;
}

- (void)setCentralView:(UIView *)centralView {
    if (_centralView != centralView) {
        [_centralView removeFromSuperview];
        _centralView = centralView;
        [self addSubview:self.centralView];
    }
}

#pragma mark - Color


-(UIColor *)fromColor{
    if(_fromColor == nil){
        _fromColor = [UIColor colorWithRed:1.0 green:0.3371 blue:0.2014 alpha:1.0];
    }
    return _fromColor;
}
-(void)setFromColor:(UIColor *)fromColor{
   // [self willChangeValueForKey: @"fromColor"];
    _fromColor = fromColor;
   // [self didChangeValueForKey: @"fromColor"];
}
-(UIColor *)toColor{
    if(_toColor == nil){
        _toColor = [UIColor colorWithRed:0.1464 green:1.0 blue:0.323 alpha:1.0];
    }
    return _toColor;
}

-(void)setToColor:(UIColor *)toColor{
   // [self willChangeValueForKey: @"toColor"];
    _toColor = toColor;
   // [self didChangeValueForKey: @"toColor"];
}
-(UIColor *)borderColor{
    if (_borderColor == nil) {
        _borderColor = self.fromColor;
    }
    return _borderColor;
}
-(UIColor *)borderColorWithProgress:(CGFloat)progress{
    
    CGFloat r=0,g=0,b=0 ;
    CGFloat r1=0,g1=0,b1=0 ;
    
    int numComponents = (int)CGColorGetNumberOfComponents(self.toColor.CGColor);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(self.toColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
    }
    
    numComponents = (int)CGColorGetNumberOfComponents(self.fromColor.CGColor);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(self.fromColor.CGColor);
        r1 = components[0];
        g1 = components[1];
        b1 = components[2];
    }
    UIColor *borderColor = [UIColor colorWithRed:r1 + (r - r1)*progress green:g1 + (g - g1)*progress blue:b1 + (b - b1)*progress alpha:1.0];
    self.progressView.shapeLayer.strokeColor = borderColor.CGColor;
    self.progressView.shapeLayer.borderColor = borderColor.CGColor;
    self.borderColor = borderColor;
    return borderColor;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.frame = self.bounds;
    self.centralView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - Progress Control

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    progress = MAX( MIN(progress, 1.0), 0.0); // keep it between 0 and 1
    
    if (_progress == progress) {
        return;
    }
    
    if (animated) {
        
        [self animateToProgress:progress];
        
    } else {
        
        [self stopAnimation];
        _progress = progress;
        [self.progressView updateProgress:_progress];
        
    }
    
    if (self.progressChangedBlock) {
        self.progressChangedBlock(self, _progress);
    }
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:YES];
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    if (_animationDuration < 0)
        return;
    
    _animationDuration = animationDuration;
}

- (void)animateToProgress:(CGFloat)progress {
    [self stopAnimation];
    
    // Add shape animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = self.animationDuration;
    animation.fromValue = @(self.progress);
    animation.toValue = @(progress);
    animation.delegate = self;
    [self.progressView.layer addAnimation:animation forKey:LLProgressViewProgressAnimationKey];
    
    CABasicAnimation *highlightAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    highlightAnimation.fromValue           = (id)self.borderColor.CGColor;
    highlightAnimation.toValue             = (id)[self borderColorWithProgress:progress].CGColor;
    highlightAnimation.removedOnCompletion = NO;
    //  [self.progressView.shapeLayer addAnimation:highlightAnimation forKey:@"strokeColor"];
    [self.progressView.shapeLayer addAnimation:highlightAnimation forKey:@"strokeColor"];
    
    // Add timer to update valueLabel
    _valueLabelProgressPercentDifference = (progress - self.progress) * 100;
    CFTimeInterval timerInterval =  self.animationDuration / ABS(_valueLabelProgressPercentDifference);
    self.valueLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                                  target:self
                                                                selector:@selector(onValueLabelUpdateTimer:)
                                                                userInfo:nil
                                                                 repeats:YES];
    
    
    _progress = progress;
}

- (void)stopAnimation {
    // Stop running animation
    [self.progressView.layer removeAnimationForKey:LLProgressViewProgressAnimationKey];
    
    // Stop timer
    [self.valueLabelUpdateTimer invalidate];
    self.valueLabelUpdateTimer = nil;
}

- (void)onValueLabelUpdateTimer:(NSTimer *)timer {
    if (_valueLabelProgressPercentDifference > 0) {
        _valueLabelProgressPercentDifference--;
    } else {
        _valueLabelProgressPercentDifference++;
    }
}

#pragma mark - Highlighting

- (void)addFill {
    if (self.fillOnTouch) {
        // update the layer model
        self.progressView.layer.backgroundColor = [self toColor].CGColor;
        
        // call block
        if (self.fillChangedBlock) {
            self.fillChangedBlock(self, YES, NO);
        }
    }
}

- (void)removeFillAnimated:(BOOL)animated {
    if (self.fillOnTouch) {
        
        // add the fade-out animation
        if (animated) {
            CABasicAnimation *highlightAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
            highlightAnimation.fromValue           = (id)self.progressView.layer.backgroundColor;
            highlightAnimation.toValue             = (id)[UIColor clearColor].CGColor;
            highlightAnimation.removedOnCompletion = NO;
            [self.progressView.layer addAnimation:highlightAnimation forKey:@"backgroundColor"];
        }
        
        // update the layer model.
        self.progressView.layer.backgroundColor = [UIColor clearColor].CGColor;
        
        // call block
        if (self.fillChangedBlock) {
            self.fillChangedBlock(self, NO, animated);
        }
    }
}

- (void)removeFill {
    [self removeFillAnimated:YES];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.progressView updateProgress:_progress];
    [self.valueLabelUpdateTimer invalidate];
    self.valueLabelUpdateTimer = nil;
}

#pragma mark - Gesture Recognizers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.centralView && [touch.view isDescendantOfView:self.centralView] && self.centralView.userInteractionEnabled) {
        return NO;
    }
    
    return YES;
}

- (void)touchDetected:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint touch = [gestureRecognizer locationOfTouch:0 inView:self];
    
    if (UIGestureRecognizerStateBegan == gestureRecognizer.state) {	// press is being held down
        
        [self addFill];
        
    } else if (UIGestureRecognizerStateChanged == gestureRecognizer.state) {	// press was recognized, but then moved
        
        if (CGRectContainsPoint(self.bounds, touch)) {
            
            [self addFill];
            
        } else {
            
            [self removeFillAnimated:NO];
            
        }
        
    } else if (UIGestureRecognizerStateEnded == gestureRecognizer.state) { // the touch has been picked up
        
        if (CGRectContainsPoint(self.bounds, touch)) {
            
            [self removeFill];
            
            if (self.didSelectBlock) {
                self.didSelectBlock(self);
            }
            
        } else {
            
            [self removeFillAnimated:NO];
            
        }
        
    } else {
        
        [self removeFillAnimated:NO];
        
    }
    
}

@end

#pragma mark - LLCircularProgressView

@implementation LLCircularProgressView

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateProgress:0];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.shapeLayer.cornerRadius = self.frame.size.width / 2.0f;
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0 * -M_PI;
    const double startAngle = 0.25 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    
    CGFloat width = self.frame.size.width;
    CGFloat borderWidth = self.shapeLayer.borderWidth;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.0f - borderWidth
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:_clockwise];
}

- (void)updateProgress:(CGFloat)progress {
    [self updatePath:progress];
}

- (void)updatePath:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = progress;
    [CATransaction commit];
}


@end
