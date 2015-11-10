//
//  LLProgressView.h
//  LLProgressView
//
//  Created by levy on 15/11/10.
//  Copyright © 2015年 levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLProgressView : UIView
/**
 *  Called when the progress view is filled with tintColor, or removed
 *
 *  Example usage would be to invert the colors on your centralView
 */
@property (nonatomic, copy) void (^fillChangedBlock)(LLProgressView *progressView, BOOL filled, BOOL animated);

/**
 *  Called on touchUpInside
 *
 *  Example usage would be to invert the colors on your centralView
 */
@property (nonatomic, copy) void (^didSelectBlock)(LLProgressView *progressView);

/**
 *  Called on setProgress
 *
 *  Example usage would be to update any central view labels
 */
@property (nonatomic, copy) void (^progressChangedBlock)(LLProgressView *progressView, CGFloat progress);

/**
 *  The view in the center of the progress view.
 *
 *  It will be centered in the view but not resized, so plan accordingly
 *
 *  Can be set to anything you want though, a label with the progress %, a stop button etc...
 *  Sits above the progressView in the layer heirarchy so it receives first tap.
 *
 *  Defaults to nil.
 */
@property (nonatomic, strong) UIView *centralView;

/**
 * Fills in the circle with the tintColor on touch.
 *
 * Fills immediately, but fades when touch removed.
 *
 * Default is YES.
 */
@property (nonatomic, assign) BOOL fillOnTouch UI_APPEARANCE_SELECTOR;

/**
 clockwise
 */
@property (nonatomic, assign) BOOL clockwise;

/**
 * The line width of the outer circle
 *
 * Default is 1.0.
 */
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 * The line width of the inner circle
 *
 * Default is 2.0.
 */
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;



/**
 */
@property (nonatomic, strong) UIColor *fromColor;

/**
 */
@property (nonatomic, strong) UIColor *toColor;

/**
 *  Gets/sets the progress, from 0.0 to 1.0. Progress < 0 is set to 0.0, progress > 1 is set to 1.0
 */
@property (nonatomic, assign) CGFloat progress;

/**
 *  The duration over which to animate the progress set. Default is 0.3 seconds. animationDuration < 0 is ignored
 */
@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

/**
 *  Changes progress animated.
 *
 *  Progress < 0 is set to 0.0, progress > 1 is set to 1.0
 *  The animation will be always linear.
 *
 *  @param progress The new progress value.
 *  @param animated Specify YES to animate the change or NO if you do not want the change to be animated.
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
