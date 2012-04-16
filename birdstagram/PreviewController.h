//
//  PreviewController.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewController : UIViewController

@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) IBOutlet UIImageView *bird;
@property (nonatomic, retain) IBOutlet UIView *previewLayer;

@property CGFloat x;
@property CGFloat y;

@property CGFloat clockwiseAngle;

@property CGFloat scale;

- (IBAction) confirm: (id) sender;
- (IBAction) cancel: (id) sender;

- (IBAction) touched:(id) sender withEvent:(UIEvent *) event;
- (IBAction) moved:(id) sender withEvent:(UIEvent *) event;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo;


+ (PreviewController *) singleton;

@end
