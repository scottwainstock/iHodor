#import "TalkerViewController.h"

@interface HodorAndBranTalkerViewController : TalkerViewController <TalkerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)sharePressed:(id)sender;
- (IBAction)selectOrTakePicture:(id)sender;
- (void)setBranImage:(UIImage *)image;
- (NSString *)branFilename;

@end