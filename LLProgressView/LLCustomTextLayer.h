//
//  LLCustomTextLayer.h
//  LLProgressView
//
//  Created by levy on 15/11/11.
//  Copyright © 2015年 levy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface LLCustomTextLayer : CATextLayer
- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(float)startNumber
                      toNumber:(float)endNumber;

- (void)jumpNumber;
@end
