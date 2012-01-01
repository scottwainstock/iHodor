//
//  HodorViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorViewController.h"

@implementation HodorViewController

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown || 
           [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait;
}

@end