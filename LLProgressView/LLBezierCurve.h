//
//  LLBezierCurve.h
//  LLProgressView
//
//  Created by levy on 15/11/11.
//  Copyright © 2015年 levy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct
{
    float x;
    float y;
} Point2D;

@interface LLBezierCurve : NSObject
Point2D PointOnCubicBezier(Point2D* cp, float t);
@end
