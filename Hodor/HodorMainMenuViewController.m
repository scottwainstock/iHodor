#import "HodorMainMenuViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "HodorTalkerViewController.h"
#import "HodorAndBranTalkerViewController.h"

@implementation HodorMainMenuViewController

- (IBAction)goButtonPressed:(id)sender {
    //HodorTalkerViewController *talkerViewController = [[HodorTalkerViewController alloc] init];
    HodorAndBranTalkerViewController *talkerViewController = [[HodorAndBranTalkerViewController alloc] init];
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
