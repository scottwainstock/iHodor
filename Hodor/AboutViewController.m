//
//  AboutViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "HodorAppDelegate.h"

@implementation AboutViewController

- (IBAction)aboutButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://beefbrain.com"]];
}

- (IBAction)iscabButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ISCAB_URL]];
}

@end