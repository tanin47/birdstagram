//
//  LoadMoreCell.m
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell


@synthesize cell;
@synthesize loading;
@synthesize label;


- (id)init
{
    self = [super init];
    if (self) {
		
		[[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil];
		
        [self addSubview:self.cell];
        
        self.frame = self.cell.frame;
        
    }
    return self;
}


- (void) startLoading
{
    [self.loading startAnimating];
    self.label.hidden = YES;
}


- (void) ok
{
    [self.loading stopAnimating];
    self.label.hidden = NO;
    self.label.text = @"OK";
}


- (void) fail
{
    [self.loading stopAnimating];
    self.label.hidden = NO;
    self.label.text = @"Fail";
}

@end
