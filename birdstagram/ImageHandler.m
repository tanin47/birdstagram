//
//  ImageHandler.m
//  foodling2
//
//  Created by Apirom Na Nakorn on 2/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageHandler.h"


@implementation ImageHandler

@synthesize image;
@synthesize imageChanged;

- (ImageHandler *) initWithSelector:(SEL) thisMethod AndTarget:(UIViewController *) thisTarget
{
	//DLog(@"");
	self = [super init];
	target = thisTarget;
	method = thisMethod;
	return self;
}


- (void) openActionSheet
{
	//DLog(@"");
    
    NSString *deleteButtonLabel = (self.image != nil)? @"Remove the current photo" : nil;
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
															 delegate:self
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:deleteButtonLabel 
													otherButtonTitles:@"From Camera", @"From Album", nil];

    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}


- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
	//DLog(@"");
	if (index == sender.destructiveButtonIndex) {
        
        if (self.image != nil) {
            [self clear];
            self.imageChanged = YES;
            [target performSelector:method];
        }
		
	} else if (index != sender.cancelButtonIndex) {
		
		NSString *button = [sender buttonTitleAtIndex:index];
		
		if ([button isEqualToString:@"From Camera"]) {
			[self takePicture];
		} else if ([button isEqualToString:@"From Album"]) {
			[self selectPicture];
		}
		
	}
}


- (void) selectPicture
{
	//DLog(@"");
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	
	imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
	
	[target presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}


- (void) takePicture
{
	//DLog(@"");
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
		return; // no camera
	}
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
	imagePicker.delegate = self;
	imagePicker.allowsEditing = NO;
	
	[target presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}


+ (UIImage*) imageWithImage: (UIImage *) image 
			  scaledToSize: (CGSize) newSize
{
	//DLog(@"");
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

+ (UIImage*)scaleToInstagramWithImage: (UIImage*) image
{
	//DLog(@"");
	UIGraphicsBeginImageContext(CGSizeMake(612, 612));
    
    int x = 0;
    int y = 0;
    
    int newWidth = 612;
    int newHeight = 612;
    
    if (image.size.width > image.size.height) {
        newWidth = newHeight * image.size.width / image.size.height;
        x = - (newWidth - 612)/2;
    } else {
        newHeight = newWidth * image.size.height / image.size.width;
        y = - (newHeight - 612)/2;
    }
    
	[image drawInRect:CGRectMake(x, y, newWidth, newHeight)];
    
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
	
	return newImage; 
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//DLog(@"");
	self.imageChanged = YES;
	
	[target dismissModalViewControllerAnimated:YES];
	
	self.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
//    if (self.image.size.width > 1200 || self.image.size.height > 1200)
//    {
//        CGFloat targetWidth = 1000;
//        CGFloat targetHeight = 1000;
//        
//        if (self.image.size.width < self.image.size.height)
//        {
//            targetWidth = (targetHeight * self.image.size.width / self.image.size.height);
//        }
//        else
//        {
//            targetHeight = (targetWidth * self.image.size.height / self.image.size.width);
//        }
//        
//        self.image = [ImageHandler imageWithImage:self.image
//                                     scaledToSize:CGSizeMake(targetWidth, targetHeight)];
//    }
	
	[target performSelector:method];
}


- (void) clear
{
	//DLog(@"");
	self.image = nil;
	self.imageChanged = NO;
}


- (void)dealloc {
	//DLog(@"");
	self.image = nil;
    [super dealloc];
}

@end
