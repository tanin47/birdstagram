//
//  UIBirdView.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBirdView.h"

@implementation UIBirdView

@synthesize box;

- (void) rotate: (CGFloat) angle
{
    self.box.transform = CGAffineTransformRotate(self.box.transform, angle);
}

- (void) pinch: (CGFloat) scale
{
    //self.box.transform = CGAffineTransformScale(self.box.transform, scale, scale);
}

- (void) translation: (CGPoint) diff
{
    //self.box.transform = CGAffineTransformTranslate(self.box.transform, diff.x, diff.y);
    self.box.center = CGPointMake(self.box.center.x + diff.x, self.box.center.y + diff.y);
}

@end
