#import "IscabAdViewController.h"
#import "HodorMainMenuViewController.h"
#import "HodorAppDelegate.h"

@implementation IscabAdViewController

- (IBAction)skipButtonPressed:(id)sender {
    HodorMainMenuViewController *mainMenuController = [[HodorMainMenuViewController alloc] init];
    
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.mainMenuViewController = mainMenuController;

    [self.navigationController pushViewController:mainMenuController animated:YES];
}

- (IBAction)iscabButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ISCAB_URL]];
}

@end