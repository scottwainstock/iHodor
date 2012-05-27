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