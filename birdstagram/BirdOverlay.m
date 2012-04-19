//
//  BirdOverlay.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirdOverlay.h"

@implementation BirdOverlay


@synthesize birdImageView;
@synthesize originalBirdPath;

- (void) setSelected:(BOOL)newOne {
    [super setSelected:newOne];
    
    if (self.selected == YES) {
        
        [UIView animateWithDuration:0.05 
                              delay:0.0 
                            options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) 
                         animations:^{
                             [UIView setAnimationRepeatCount:3.0];
                             self.birdImageView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             self.birdImageView.alpha = 1.0;
                         }];


    }
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
	//DLog(@"");
	if (self = [super initWithCoder:aDecoder]) {
		[self setup];
	}
	
	return self;
}


- (void) setup
{

}


- (void) setOriginalBirdPath: (NSString *) path {
    
    [originalBirdPath release];
    originalBirdPath = [path retain];
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * birdPath = [resourcePath stringByAppendingPathComponent:path];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:birdPath];
    
    if (self.birdImageView == nil) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:self.frame];
        self.birdImageView = v;
        [self addSubview:v];
        [v release];
    }
    
    self.birdImageView.image = image;
    [image release];
}


@end
