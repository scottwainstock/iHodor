#import "TalkerViewController.h"
#import "HodorAppDelegate.h"

@implementation TalkerViewController

@synthesize delegate;

HodorAppDelegate *app;

- (IBAction)backButtonPressed:(id)sender {
    if (app.talking)
        return;
    
    [app pauseListening];
    
    [super backButtonPressed:sender];
}

- (IBAction)hodorPressed:(id)sender {
    [app hodor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < MOUTH_ANIMATION_IMAGE_COUNT; i++)
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", [delegate mouthFilename], i]]];
        
    [app initializeMouthWithImages:images dimensions:[delegate mouthDimensions]];
    [self.view addSubview:app.animatedImages];
    
    [app beginListening];    
}

@end