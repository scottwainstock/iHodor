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