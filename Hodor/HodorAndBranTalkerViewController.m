#import "HodorAndBranTalkerViewController.h"
#import "HodorAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation HodorAndBranTalkerViewController

HodorAppDelegate *app;

- (CGRect)mouthDimensions {
    return CGRectMake(
        70,
        378,
        [self mouthWidth],
        [self mouthHeight]
    );
}

- (int)mouthWidth  { return 80; }
- (int)mouthHeight { return 30; }

- (NSString *)mouthFilename { return @"small_mouth"; }

- (void)viewDidLoad {
    [super viewDidLoad];

    app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[app branFilename]])
        [self setBranImage:[UIImage imageWithContentsOfFile:[app branFilename]]];
}

- (IBAction)selectOrTakePicture:(id)sender {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    [imagePicker setSourceType:[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ?
        UIImagePickerControllerSourceTypeCamera : 
        UIImagePickerControllerSourceTypePhotoLibrary
    ];

    [imagePicker setDelegate:self];
    
	[self presentModalViewController:imagePicker animated:YES];
}

- (void)setBranImage:(UIImage *)image {
    UIImageView *bran = [[UIImageView alloc] initWithImage:image];
    [bran.layer setMasksToBounds:YES];
    [bran.layer setCornerRadius:10.0];
    [bran setFrame:CGRectMake(BRAN_X, BRAN_Y, BRAN_WIDTH, BRAN_HEIGHT)];
    
    [self.view addSubview:bran];    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {    
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize newSize = CGSizeMake(BRAN_WIDTH, BRAN_HEIGHT);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    [UIImagePNGRepresentation(resizedImage) writeToFile:[app branFilename] atomically:YES];
        
    [self setBranImage:resizedImage];    
    
	[self dismissModalViewControllerAnimated:YES];
}

@end