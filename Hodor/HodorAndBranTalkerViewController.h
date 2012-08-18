#import "TalkerViewController.h"

@interface HodorAndBranTalkerViewController : TalkerViewController <TalkerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)selectOrTakePicture:(id)sender;
- (void)setBranImage:(UIImage *)image;

@end