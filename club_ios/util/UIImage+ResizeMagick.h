//
//  UIImage+ResizeMagick.h
//

//
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeMagick)

- (NSString *) resizedAndReturnPath;
- (NSData *) resizedAndReturnData;
- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;

@end
