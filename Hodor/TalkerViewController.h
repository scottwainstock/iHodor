#import "HodorViewController.h"

@protocol TalkerDelegate 
- (CGRect)mouthDimensions;
- (int)mouthWidth;
- (int)mouthHeight;
- (NSString *)mouthFilename;
@end

@interface TalkerViewController : HodorViewController {
    id <TalkerDelegate> __unsafe_unretained delegate;
}

@property(nonatomic,unsafe_unretained)id delegate;

- (IBAction)hodorPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end