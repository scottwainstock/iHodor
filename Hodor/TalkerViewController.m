//
//  TalkerViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TalkerViewController.h"
#import "HodorAppDelegate.h"

@implementation TalkerViewController

HodorAppDelegate *app;

- (IBAction)backButtonPressed:(id)sender {
    if (app.talking)
        return;
    
    [app pauseListening];

    [super backButtonPressed:sender];
}

- (IBAction)hodorPressed:(id)sender {
    [app hodor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view addSubview:app.animatedImages];
    
    [app beginListening];    
}

@end