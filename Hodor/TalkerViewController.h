#import "HodorViewController.h"

@protocol TalkerDelegate 
- (CGRect)mouthDimensions;
- (int)mouthWidth;
- (int)mouthHeight;
- (NSString *)mouthFilename;
@end

@interface TalkerViewController : HodorViewController {
    id <TalkerDelegate> delegate;
}

@property(nonatomic,assign)id delegate;

- (IBAction)hodorPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end