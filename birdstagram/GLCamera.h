//
//  ColorTrackingCamera.h
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/9/2010.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol GLCameraDelegate;

@interface GLCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
	AVCaptureVideoPreviewLayer *videoPreviewLayer;
	AVCaptureSession *captureSession;
	AVCaptureDeviceInput *videoInput;
	AVCaptureVideoDataOutput *videoOutput;
    
    BOOL isRunning;
}

@property(nonatomic, assign) id<GLCameraDelegate> delegate;
@property(readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

- (void) start;
- (void) stop;

@end

@protocol GLCameraDelegate
- (void)cameraHasConnected;
- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;
@end
