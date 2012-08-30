//
//  ViewController.h
//  AJIndeterminateProgressPanelDemo
//
//  Created by Alberto Jerez on 21/08/12.
//  Copyright (c) 2012 CodeApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJProgressPanel.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (nonatomic,strong) AJProgressPanel *panel;
@property (nonatomic,strong) AJProgressPanel *panel2;

- (IBAction)changeProgress:(id)sender;
- (IBAction)hide:(id)sender;
- (IBAction)show:(id)sender;
@end
