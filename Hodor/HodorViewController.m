#import "HodorViewController.h"
#import "HodorTalkerViewController.h"
#import "HodorAndBranTalkerViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "HodorAppDelegate.h"

@implementation HodorViewController

@synthesize menuBarDelegate;

- (void)viewDidLoad {
    self.menuBarDelegate = self;
    self.menuBar.delegate = self;

    [super viewDidLoad];
}

- (void)backButtonPressed {
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];

    [self.navigationController popToViewController:app.mainMenuViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown || 
           [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait;
}

- (void)showChat:(bool)animated {
    HodorTalkerViewController *hodorViewController = [[HodorTalkerViewController alloc] init];
    [self.navigationController pushViewController:hodorViewController animated:animated];
}

- (void)showPose:(bool)animated {
    HodorAndBranTalkerViewController *hodorAndBranTalkerViewController = [[HodorAndBranTalkerViewController alloc] init];
    [self.navigationController pushViewController:hodorAndBranTalkerViewController animated:animated];
}

- (void)showAbout:(bool)animated {
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:animated];
}

- (void)showHelp:(bool)animated {
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:helpViewController animated:animated];
}

@end