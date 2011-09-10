//
//  HodorViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorViewController.h"
#import "AboutViewController.h"

@implementation HodorViewController

- (IBAction)goButtonPressed:(id)sender {
    NSLog(@"GO");
}

- (IBAction)aboutButtonPressed:(id)sender {
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
    NSLog(@"ABOUT");
}

- (IBAction)helpButtonPressed:(id)sender {
    NSLog(@"HELP");
}

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end