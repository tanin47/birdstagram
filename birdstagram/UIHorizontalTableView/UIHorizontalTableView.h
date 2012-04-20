//
//  UIHorizontalTableView.h
//  UIHorizontalTableView
//
//  Created by Apirom Na Nakorn on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UIHorizontalTableView;

@protocol UIHorizontalTableViewDelegate


@optional
- (void) tableView: (UIHorizontalTableView *) tableView didSelectColumnAt: (int) columnIndex;

@required
- (CGFloat) tableViewWidthForColumn: (UIHorizontalTableView *) tableView;
- (NSInteger) numberOfColumns: (UIHorizontalTableView *) tableView;
- (UIView *) tableView: (UIHorizontalTableView *) tableView cellForColumnAt: (int) columnIndex;

@end


@interface UIHorizontalTableView : UIScrollView<UIScrollViewDelegate> {
    NSInteger numberOfColumns;
    CGFloat widthOfCell;
    BOOL alreadyInit;
}

@property (nonatomic, retain) IBOutlet id<UIHorizontalTableViewDelegate> horizontalDelegate;
@property (nonatomic, retain) NSMutableArray *cells;

- (void) setup;
- (UIView *) dequeueReusableCell;
- (IBAction) cellClicked: (UIGestureRecognizer *) recognizer;

- (void) reloadData;

@end
