#import "HodorMenuBar.h"

@implementation HodorMenuBar

@synthesize delegate;

- (void)awakeFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HodorMenuBar" owner:self options:nil];
    [self addSubview:[views objectAtIndex:0]];
    
    [super awakeFromNib];
}

- (IBAction)backButtonPressed {
    [self.delegate backButtonPressed];
}

- (IBAction)chatButtonPressed {
    [self.delegate showChat:NO];
}

- (IBAction)poseButtonPressed {
    [self.delegate showPose:NO];
}

- (IBAction)shareButtonPressed {
    NSLog(@"SHARE");
}

@end