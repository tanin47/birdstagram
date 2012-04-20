//
//  UIBirdPanel.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bird.h"
#import "LoadMoreCell.h"


@class UIBirdPanel;

@protocol UIBirdPanelDelegate

- (void) birdPanel: (UIBirdPanel *) birdPanel didSelectBird: (Bird *) bird; 

@end



@interface UIBirdPanel : UIHorizontalTableView<UIHorizontalTableViewDelegate>

@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, retain) NSString *listUrl;
@property (nonatomic, retain) NSMutableArray *localBirds;
@property (nonatomic, retain) NSMutableArray *remoteBirds;
@property (nonatomic, retain) id<UIBirdPanelDelegate> birdDelegate;
@property (nonatomic, retain) LoadMoreCell *loadMoreCell;

- (void) setupBirds;
- (void) loadMore;
- (void) ensureDir: (NSString *) path;

@end
