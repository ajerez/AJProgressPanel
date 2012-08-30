//
//  ViewController.m
//  AJIndeterminateProgressPanelDemo
//
//  Created by Alberto Jerez on 21/08/12.
//  Copyright (c) 2012 CodeApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
@synthesize secondView = _secondView;

- (void)viewDidLoad
{
    [self showPanels];

    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)showPanels{
    //Default
    self.panel = [AJProgressPanel showInView:self.view];
    
    //Custom
    self.panel2 = [AJProgressPanel showInView:self.secondView position:AJPanelPositionBottom];
    self.panel2.enableShadow = NO;
    self.panel2.startGradientColor = [UIColor colorWithWhite:0.35f alpha:1.0f];
    self.panel2.endGradientColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    self.panel2.stripesColor = [UIColor colorWithRed:40.0f/255 green:140.0f/255 blue:193.0f/255 alpha:1.0f];
    self.panel2.progressColor = [UIColor colorWithRed:50.0f/255 green:170.0f/255 blue:193.0f/255 alpha:0.7f];
}

- (IBAction)changeProgress:(id)sender {
    
    if (self.panel.progress >= 1.0f) self.panel.progress = 0.0f; //Default setter -> animated = FALSE
    if (self.panel2.progress >= 1.0f) self.panel2.progress = 0.0f;

    [self.panel setProgress:self.panel.progress+0.1f animated:YES];
    [self.panel2 setProgress:self.panel2.progress+0.2f animated:YES];
}

- (IBAction)hide:(id)sender {
    [self.panel hideAnimated:YES];
    [self.panel2 hideAnimated:YES];
}

- (IBAction)show:(id)sender {
    [self showPanels];
}
@end
