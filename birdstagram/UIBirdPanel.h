//
//  UIBirdPanel.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bird.h"

@class UIBirdPanel;



@protocol UIBirdPanelDelegate

- (void) birdPanel: (UIBirdPanel *) birdPanel didSelectBird: (Bird *) bird; 

@end



@interface UIBirdPanel : UIHorizontalTableView<UIHorizontalTableViewDelegate>

@property (nonatomic, retain) NSMutableArray *birds;
@property (nonatomic, retain) id<UIBirdPanelDelegate> birdDelegate;

- (void) setupBirds;

@end
