#import "HodorAndBranTalkerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define BRAN_WIDTH  96
#define BRAN_HEIGHT 143
#define BRAN_X      215
#define BRAN_Y      105

@implementation HodorAndBranTalkerViewController

- (CGRect)mouthDimensions {
    return CGRectMake(
        75,
        395,
        [self mouthWidth],
        [self mouthHeight]
    );
}

- (int)mouthWidth  { return 70; }
- (int)mouthHeight { return 23; }

- (NSString *)mouthFilename { return @"small_mouth"; }

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[NSFileManager defaultManager] fileExistsAtPath:[self branFilename]])
        [self setBranImage:[UIImage imageWithContentsOfFile:[self branFilename]]];    
}

- (NSString *)branFilename {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/you_as_bran.png"];
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
        
    [UIImagePNGRepresentation(resizedImage) writeToFile:[self branFilename] atomically:YES];
        
    [self setBranImage:resizedImage];    
    
	[self dismissModalViewControllerAnimated:YES];
}

@end