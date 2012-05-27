#import "HodorAndBranTalkerViewController.h"
#import "HodorAppDelegate.h"

@implementation HodorAndBranTalkerViewController

- (CGRect)mouthDimensions {
    return CGRectMake(
        75,
        290,
        [self mouthWidth],
        [self mouthHeight]
    );
}

- (int)mouthWidth  { return 63; }
- (int)mouthHeight { return 23; }

- (NSString *)mouthFilename { return @"small_mouth"; }

- (IBAction)sharePressed:(id)sender {
    NSLog(@"SHARE");
}

@end