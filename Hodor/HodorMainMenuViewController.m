#import "HodorMainMenuViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "HodorTalkerViewController.h"
#import "HodorAndBranTalkerViewController.h"

@implementation HodorMainMenuViewController

- (IBAction)toggleTalker:(id)sender {
    BOOL branType = [[NSUserDefaults standardUserDefaults] boolForKey:@"branType"];
    [[NSUserDefaults standardUserDefaults] setBool:!branType forKey:@"branType"];
}

- (IBAction)chatButtonPressed:(id)sender {
    HodorTalkerViewController *hodorViewController = [[HodorTalkerViewController alloc] init];
    [self.navigationController pushViewController:hodorViewController animated:YES];
}

- (IBAction)poseButtonPressed:(id)sender {
    HodorAndBranTalkerViewController *hodorAndBranTalkerViewController = [[HodorAndBranTalkerViewController alloc] init];
    [self.navigationController pushViewController:hodorAndBranTalkerViewController animated:YES];
}

- (IBAction)aboutButtonPressed:(id)sender {
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:YES];
}

- (IBAction)helpButtonPressed:(id)sender {
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:helpViewController animated:YES];
}

@end
