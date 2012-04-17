//
//  MenuController.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuController : UIViewController

@property (nonatomic, retain) ImageHandler *imageHandler;


- (IBAction) startCamera: (id) sender;

//- (void) previewPhoto;
//- (IBAction) getPhoto: (id) sender;

+ (MenuController *) singleton;

@end
