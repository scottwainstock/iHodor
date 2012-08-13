#import "HodorViewController.h"
#import "HodorMenuBar.h"

@protocol TalkerDelegate 
- (CGRect)mouthDimensions;
- (int)mouthWidth;
- (int)mouthHeight;
- (NSString *)mouthFilename;
@end

@interface TalkerViewController : HodorViewController {
    id <TalkerDelegate> __unsafe_unretained talkerDelegate;
}

@property(nonatomic,unsafe_unretained)id talkerDelegate;

- (IBAction)hodorPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end