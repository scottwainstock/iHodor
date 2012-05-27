#import "HodorTalkerViewController.h"
#import "HodorAppDelegate.h"

@implementation HodorTalkerViewController

- (CGRect)mouthDimensions {
    return CGRectMake(
        ([UIScreen mainScreen].bounds.size.width / 2) - ([self mouthWidth] / 2), 
        ([UIScreen mainScreen].bounds.size.height / 2) - ([self mouthHeight] /2) + HEIGHT_OFFSET,
        [self mouthWidth],
        [self mouthHeight]
    );
}

- (int)mouthWidth  { return 175; }
- (int)mouthHeight { return 65;  }

- (NSString *)mouthFilename { return @"mouth"; }

@end