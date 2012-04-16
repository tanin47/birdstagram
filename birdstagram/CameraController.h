//
//  CameraController.h
//  birdstagram
//
//  Created by Apirom Na Nakorn on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLCamera.h"

@interface CameraController : UIViewController<GLCameraDelegate>


@property (nonatomic, retain) IBOutlet UIView* previewLayer;
@property (nonatomic, retain) GLCamera *camera;


- (void) processNewCameraFrameWithC: (CVImageBufferRef) cameraFrame;


+ (CameraController *) singleton;

@end
