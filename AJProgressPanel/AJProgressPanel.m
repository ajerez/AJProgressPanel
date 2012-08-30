//
//  AJIndeterminateProgressPanel.m
//  AJIndeterminateProgressPanelDemo
//
//  Created by Alberto Jerez on 21/08/12.
//  Copyright (c) 2012 CodeApps. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
//  (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "AJProgressPanel.h"

const CGFloat BAR_HEIGHT = 8.0f; //Progress bar height

/////////////////////////////////////////////////////////////////////////////
#pragma mark - AJProgressLayer
/////////////////////////////////////////////////////////////////////////////

@interface AJProgressLayer : CALayer

@property (nonatomic, strong) UIColor *startGradientColor;
@property (nonatomic, strong) UIColor *endGradientColor;
@property (nonatomic, strong) UIColor *stripesColor;
@property (nonatomic, assign) BOOL enableShadow;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat moveFactor;
@property (nonatomic, strong) UIColor *progressColor;

@end

@implementation AJProgressLayer

- (id)initWithLayer:(AJProgressLayer *)layer{
    self = [super initWithLayer:layer];
    if (self){
        self.progress = layer.progress;
        self.enableShadow = layer.enableShadow;
        self.stripesColor = layer.stripesColor;
        self.endGradientColor = layer.endGradientColor;
        self.startGradientColor = layer.startGradientColor;
        self.moveFactor = layer.moveFactor;
        self.progressColor = layer.progressColor;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"progress"])
        return YES;
    else
        return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx{
    
    CGRect rect = self.bounds;
    CGContextClipToRect(ctx, rect);
    
    
    self.moveFactor = self.moveFactor > 14.0f ? 0.0f : ++self.moveFactor;
    
    // Background gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(id)self.startGradientColor.CGColor, (id)self.endGradientColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint start = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint end = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    // Lines
    CGContextSaveGState(ctx);
    CGContextClipToRect(ctx, self.bounds);
    CGMutablePathRef path = CGPathCreateMutable();
    int lines = (self.bounds.size.width/8.0f + self.bounds.size.height);
    for(int i = -1; i < lines; i++) {
        CGPathMoveToPoint(path, NULL, 8.0f * i + self.moveFactor, 0.0f);
        CGPathAddLineToPoint(path, NULL, 1.0f, 8.0f * i + self.moveFactor);
    }
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    CGContextSetLineWidth(ctx, 3.0f);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(ctx, self.stripesColor.CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    // Progress
    if (self.progress != 0.0f){
        CGContextSaveGState(ctx);
        CGContextClipToRect(ctx, self.bounds);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, 0.0f, 4.0f);
        CGPathAddLineToPoint(progressPath, NULL, self.progress * self.bounds.size.width, 4.0f);
        CGContextAddPath(ctx, progressPath);
        CGPathRelease(progressPath);
        CGContextSetLineWidth(ctx, BAR_HEIGHT);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetStrokeColorWithColor(ctx, self.progressColor.CGColor);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
    
}

@end


/////////////////////////////////////////////////////////////////////////////
#pragma mark - AJProgressPanel
/////////////////////////////////////////////////////////////////////////////

@interface AJProgressPanel ()

@property (nonatomic, assign) NSTimer *animationTimer;
@property (nonatomic) AJPanelPosition position;

- (void)_setup;

@end

@implementation AJProgressPanel

////////////////////////////////////////////////////////////////////////
#pragma mark - Setup
////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (AJProgressLayer *)currentLayer{
    return (AJProgressLayer *)self.layer;
}

+ (Class)layerClass{
    return [AJProgressLayer class];
}

- (void)_setup{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.alpha = 0.0f;
    self.animationTimer = nil;
    self.enableShadow = YES;
    self.startGradientColor = [UIColor colorWithWhite:0.90f alpha:1.0f];
    self.endGradientColor = [UIColor colorWithWhite:0.80f alpha:1.0f];
    self.stripesColor = [UIColor colorWithWhite:1.0f alpha:0.95];
    self.progressColor = [UIColor colorWithRed:230.0f/255 green:153.0f/255 blue:10.0/255 alpha:0.5];
    self.progress = 0.0f;
}

- (void)drawRect:(CGRect)rect{
}

#pragma mark Progress
- (CGFloat)progress{
    return [self currentLayer].progress;
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    CGFloat newProgress = MIN(MAX(progress, 0.0f), 1.0f);
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = ([self currentLayer].progress - newProgress);
        animation.fromValue = [NSNumber numberWithFloat:[self currentLayer].progress];
        animation.toValue = [NSNumber numberWithFloat:progress];
        [[self currentLayer] addAnimation:animation forKey:@"progress"];
    }
    else
        [[self currentLayer] setNeedsDisplay];
    
    
    [self currentLayer].progress = newProgress;
}

#pragma mark startGradientColor
- (UIColor *)startGradientColor{
    return [self currentLayer].startGradientColor;
}

- (void)setStartGradientColor:(UIColor *)startGradientColor
{
    [self currentLayer].startGradientColor = startGradientColor;
    [[self currentLayer] setNeedsDisplay];
}

#pragma mark endGradientColor
- (UIColor *)endGradientColor{
    return [self currentLayer].endGradientColor;
}

- (void)setEndGradientColor:(UIColor *)endGradientColor
{
    [self currentLayer].endGradientColor = endGradientColor;
    [[self currentLayer] setNeedsDisplay];
}

#pragma mark stripesColor
- (UIColor *)stripesColor{
    return [self currentLayer].stripesColor;
}

- (void)setStripesColor:(UIColor *)stripesColor
{
    [self currentLayer].stripesColor = stripesColor;
    [[self currentLayer] setNeedsDisplay];
}

#pragma mark progressColor
- (UIColor *)progressColor{
    return [self currentLayer].progressColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    [self currentLayer].progressColor = progressColor;
    [[self currentLayer] setNeedsDisplay];
}

#pragma mark enableShadow
- (BOOL)enableShadow{
    return [self currentLayer].enableShadow;
}

- (void)setEnableShadow:(BOOL)enableShadow
{
    [self currentLayer].enableShadow = enableShadow;
    // Draw Shadow
    if (self.enableShadow){
        CGFloat fixedOffset = (self.position == AJPanelPositionTop ? 1.0f : -1.0);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowOffset = CGSizeMake(0.0, fixedOffset);
        self.layer.shadowRadius = 2.0f;
    }
    [[self currentLayer] setNeedsDisplay];
}

#pragma mark - Show
+ (AJProgressPanel *)showInView:(UIView *)view{
    
    return [self showInView:view position:AJPanelPositionTop];
}

+ (AJProgressPanel *)showInView:(UIView *)view position:(AJPanelPosition)position {
    CGFloat fixedY = (position == AJPanelPositionTop ? 0.0f : view.bounds.size.height);
    AJProgressPanel *progressView = [[self alloc] initWithFrame:CGRectMake(0.0f, fixedY, view.bounds.size.width, 1.0f)];
    progressView.position = (position == AJPanelPositionTop ? AJPanelPositionTop : AJPanelPositionBottom);
    
    
    [view addSubview:progressView];
    [progressView setNeedsDisplay];
    
    if (nil == progressView.animationTimer){
        progressView.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                                       target:progressView
                                                                     selector:@selector(setNeedsDisplay)
                                                                     userInfo:nil
                                                                      repeats:YES];
    }
    
    // Show animation
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         progressView.alpha = 1.0f;
                         progressView.frame = CGRectMake(0.0,
                                                         (position == AJPanelPositionTop ? 0.0f : fixedY-BAR_HEIGHT),
                                                         view.bounds.size.width,
                                                         BAR_HEIGHT);
                     }
                     completion:nil];
    
    return progressView;
}

#pragma mark - Hide
- (void)hide{
    [self hideAnimated:NO];
}
- (void)hideAnimated:(BOOL)animated{
    if (animated){
        CGFloat fixedY = (self.position == AJPanelPositionTop ? 0.0f : self.superview.bounds.size.height);
        [UIView animateWithDuration:0.3f
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.alpha = 0.0f;
                             self.frame = CGRectMake(0.0,
                                                     fixedY,
                                                     self.frame.size.width,
                                                     1.0f);
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 if ([self.animationTimer isValid])
                                     [self.animationTimer invalidate];
                                 
                                 [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.1f];
                             }
                         }];
    }
    else{
        if ([self.animationTimer isValid])
            [self.animationTimer invalidate];
        [self removeFromSuperview];
    }
}


@end
