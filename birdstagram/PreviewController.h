//
//  PreviewController.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBirdPanel.h"

@interface PreviewController : UIViewController<UIDocumentInteractionControllerDelegate, UIBirdPanelDelegate>

@property (nonatomic, retain) NSString *photoPath;

@property (nonatomic, retain) IBOutlet UIBirdView *previewLayer;

@property (nonatomic, retain) UIBirdPanel *birdPanel;

@property (nonatomic, retain) UIDocumentInteractionController *instagram;

@property CGFloat x;
@property CGFloat y;

@property CGFloat clockwiseAngle;

@property CGFloat scale;

- (UIImage *) getFinalImage;

- (IBAction) sendToInstagram: (id) sender;
- (IBAction) saveToAlbum: (id) sender;
- (IBAction) cancel: (id) sender;

- (IBAction) toggleBirdPanel: (id) sender;
- (IBAction) openBirdPanel: (id) sender;
- (IBAction) closeBirdPanel: (id) sender;

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo;


+ (PreviewController *) singleton;

@end
