#import "HodorMainMenuViewController.h"

@implementation HodorMainMenuViewController

- (IBAction)chatButtonPressed:(id)sender {
    [self showChat:YES];
}

- (IBAction)poseButtonPressed:(id)sender {
    [self showPose:YES];
}

- (IBAction)aboutButtonPressed:(id)sender {
    [self showAbout:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    [self showHelp:YES];
}

@end