//
//  UIHorizontalTableView.m
//  UIHorizontalTableView
//
//  Created by Apirom Na Nakorn on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIHorizontalTableView.h"

@implementation UIHorizontalTableView


@synthesize horizontalDelegate;
@synthesize cells;


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
    self.alwaysBounceVertical = NO;
    self.alwaysBounceHorizontal = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.directionalLockEnabled = YES;
    
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 1.0;
    
    self.delegate = self;
}


- (UIView *) dequeueReusableCell
{
    return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"At %f %f %f", self.contentOffset.x, self.contentOffset.y, self.contentSize.width);
}


//- (void) didMoveToSuperview
- (void) didMoveToWindow
{
    [super didMoveToWindow];
    
    NSLog(@"%@", self.horizontalDelegate);
    numberOfColumns = [self.horizontalDelegate numberOfColumns:self];
    
    widthOfCell = [self.horizontalDelegate tableViewWidthForColumn:self];
    CGFloat sumWidth = [self.horizontalDelegate tableViewWidthForColumn:self] * numberOfColumns;
    
    self.contentSize = CGSizeMake(sumWidth, self.frame.size.height);
    
    NSLog(@"contentWidth = %f", sumWidth);
    NSLog(@"frameWidth = %f", self.frame.size.width);
    
    
    for (int i=0;i<numberOfColumns;i++) {
        
        UIView *v = [self.horizontalDelegate tableView:self cellForColumnAt:i];
        v.frame = CGRectMake(i * widthOfCell, 0, v.frame.size.width,  v.frame.size.height);
        
        v.tag = i;
        
        [self addSubview:v];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClicked:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        
        [v addGestureRecognizer:singleTap];
        [singleTap release];
    }
    
    
}

- (IBAction) cellClicked: (UIGestureRecognizer *) recognizer
{
    NSLog(@"Clicked %d", recognizer.view.tag);
    [self.horizontalDelegate tableView:self didSelectColumnAt:recognizer.view.tag];
}


@end
