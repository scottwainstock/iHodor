#import "TalkerViewController.h"
#import "HodorAppDelegate.h"

@implementation TalkerViewController

@synthesize talkerDelegate;

HodorAppDelegate *app;

- (IBAction)backButtonPressed:(id)sender {    
    if (app.talking)
        return;
    
    [app pauseListening];
    
    [super backButtonPressed];
}

- (IBAction)hodorPressed:(id)sender {
    [app hodor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.talkerDelegate = self;
    
    app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < MOUTH_ANIMATION_IMAGE_COUNT; i++)
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", [talkerDelegate mouthFilename], i]]];
        
    [app initializeMouthWithImages:images dimensions:[talkerDelegate mouthDimensions]];
    [self.view addSubview:app.animatedImages];
    
    [app beginListening];    
}

@end