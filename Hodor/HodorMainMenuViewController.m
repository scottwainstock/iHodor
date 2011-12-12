//
//  HodorViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorMainMenuViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "TalkerViewController.h"

@implementation HodorMainMenuViewController

- (IBAction)goButtonPressed:(id)sender {
    TalkerViewController *talkerViewController = [[TalkerViewController alloc] init];
    [self.navigationController pushViewController:talkerViewController animated:YES];
    [talkerViewController release];
}

- (IBAction)aboutButtonPressed:(id)sender {
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
}

- (IBAction)helpButtonPressed:(id)sender {
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:helpViewController animated:YES];
    [helpViewController release];
}

@end
