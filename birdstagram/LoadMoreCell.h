//
//  LoadMoreCell.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadMoreCell : UIView


@property (nonatomic, retain) IBOutlet UIView* cell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (void) startLoading;
- (void) ok;
- (void) fail;


@end
