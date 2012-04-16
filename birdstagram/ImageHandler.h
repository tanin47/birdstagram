//
//  ImageHandler.h
//  foodling2
//
//  Created by Apirom Na Nakorn on 2/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageHandler : NSObject<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	SEL method;
	UIViewController *target;
}

@property (nonatomic, retain) UIImage *image;
@property BOOL imageChanged;

+ (UIImage*)imageWithImage:(UIImage*)image 
			  scaledToSize:(CGSize)newSize;

+ (UIImage*)scaleToInstagramWithImage: (UIImage*) image;

- (ImageHandler *) initWithSelector:(SEL)thisMethod AndTarget:(UIViewController *) thisTarget;
- (void) openActionSheet;
- (void) selectPicture;
- (void) takePicture;
- (void) clear;


@end
