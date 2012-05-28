#import "HodorMainMenuViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"

@implementation HodorMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UISwitch *talkerType = [[UISwitch alloc] initWithFrame:CGRectZero];
    [talkerType addTarget:self action:@selector(toggleTalker:) forControlEvents:UIControlEventValueChanged];
    [talkerType setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"branType"]];
        
    [self.view addSubview:talkerType];
    
    [talkerType release];
}

- (IBAction)toggleTalker:(id)sender {
    BOOL branType = [[NSUserDefaults standardUserDefaults] boolForKey:@"branType"];
    [[NSUserDefaults standardUserDefaults] setBool:!branType forKey:@"branType"];
}

- (IBAction)goButtonPressed:(id)sender {
    NSString *viewControllerClassName = [[NSUserDefaults standardUserDefaults] boolForKey:@"branType"] ? 
        @"HodorAndBranTalkerViewController" :
        @"HodorTalkerViewController"
    ;
            
    id viewController = [[NSClassFromString(viewControllerClassName) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
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
