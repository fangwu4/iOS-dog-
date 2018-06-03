#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)cropToSize:(CGSize)size;
- (CVPixelBufferRef)pixelBufferFromCGImage:(UIImage *)image ;

@end
