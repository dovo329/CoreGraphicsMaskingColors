//
//  MaskImage.m
//  CoreGraphicsMaskingColors
//
//  Created by Douglas Voss on 6/12/15.
//  Copyright (c) 2015 DougsApps. All rights reserved.
//

#import "MaskImage.h"

@implementation MaskImage

- (void) drawRect:(CGRect)rect
{
    //UIImage *inputImage = [UIImage imageNamed:@"TestColorShapeBlack"];
    UIImage *inputImage = [UIImage imageNamed:@"TestColorShape"];
    //UIImage *inputImage = [UIImage imageNamed:@"ghosty"];
    //const CGFloat colorMasking[6]={255.0, 255.0, 0.0, 0.0, 0.0, 0.0};
    //CGImageRef maskedImg = CGImageCreateWithMaskingColors(inputImage.CGImage, colorMasking);
    //CGContextSetRGBFillColor(context, 255.0, 255.0, 0.0, 1.0);
    //CGContextFillRect(context, rect);
    //CGContextTranslateCTM(context, 0, rect.size.height);
    //CGContextScaleCTM(context, 1.0, -1.0);
    //CGContextDrawImage (context, rect, maskedImg);
    
    CGImageRef inputCGImage = inputImage.CGImage;
    
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    //CGContextDrawImage(context, rect, inputCGImage);
    
    #define Mask8(x) ( (x) & 0xFF )
    #define RED(x) ( Mask8(x) )
    #define GREEN(x) ( Mask8(x >> 8 ) )
    #define BLUE(x) ( Mask8(x >> 16) )
    
    NSLog(@"Brightness of image:");
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            //printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
            //printf("%d ",R(color));
            if (RED(color) == 255 && BLUE(color) == 0 && GREEN(color) == 0)
            {
                // change red to green
                color = 0x0000ff00;
            }
            
            if (RED(color) == 0 && BLUE(color) == 255 && GREEN(color) == 0)
            {
                // change blue to pink
                color = 0x00ff00ff;
            }
            *currentPixel = color;
            currentPixel++;
        }
        printf("\n");
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    //CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, inputCGImage);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, newCGImage);
}

@end
