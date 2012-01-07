//
//  IscabAd.m
//  Hodor
//
//  Created by Scott Wainstock on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "IscabAdViewController.h"
#import "HodorMainMenuViewController.h"
#import "HodorAppDelegate.h"

@implementation IscabAdViewController

- (IBAction)skipButtonPressed:(id)sender {
    HodorMainMenuViewController *mainMenuController = [[HodorMainMenuViewController alloc] init];    
    [self.navigationController pushViewController:mainMenuController animated:YES];
    [mainMenuController release];
}

- (IBAction)iscabButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ISCAB_URL]];
}

@end