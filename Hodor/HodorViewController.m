#import "HodorViewController.h"
#import "HodorTalkerViewController.h"
#import "HodorAndBranTalkerViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "HodorAppDelegate.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation HodorViewController

@synthesize menuBarDelegate;

HodorAppDelegate *app;

- (void)viewDidLoad {
    self.menuBarDelegate = self;
    self.menuBar.delegate = self;
    
    app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];

    [super viewDidLoad];
}

- (void)backButtonPressed {
    [self.navigationController popToViewController:app.mainMenuViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown || 
           [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait;
}

- (void)showChat:(bool)animated {
    HodorTalkerViewController *hodorViewController = [[HodorTalkerViewController alloc] init];
    [self.navigationController pushViewController:hodorViewController animated:animated];
}

- (void)showPose:(bool)animated {
    HodorAndBranTalkerViewController *hodorAndBranTalkerViewController = [[HodorAndBranTalkerViewController alloc] init];
    [self.navigationController pushViewController:hodorAndBranTalkerViewController animated:animated];
}

- (void)showAbout:(bool)animated {
    AboutViewController *aboutViewController = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutViewController animated:animated];
}

- (void)showHelp:(bool)animated {
    HelpViewController *helpViewController = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:helpViewController animated:animated];
}

- (void)showShare {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if ([TWTweetComposeViewController canSendTweet]) {
                TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
                [tweetSheet setInitialText:@"Hodor"];
                [self presentModalViewController:tweetSheet animated:YES];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Unable to Tweet"
                                          message:@"Unable to send a Tweet right now. Make sure you have a Twitter account setup, and that you have Internet access."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil
                                          ];
                [alertView show];
            }
            
            break;
        case 1:
            {
                NSArray *permissions = @[@"publish_actions", @"publish_stream", @"manage_pages"];
                [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                    if (session.isOpen) {
                        if (![[NSFileManager defaultManager] fileExistsAtPath:[app branFilename]]) {
                            UIAlertView *alertView = [[UIAlertView alloc]
                                                      initWithTitle:@"Unable to Share"
                                                      message:@"You need to take a picture of yourself with Hodor before I can share it with Facebook."
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil
                                                      ];
                            [alertView show];

                            return;
                        }
                                                
                        UIImage *bran = [UIImage imageWithContentsOfFile:[app branFilename]];
                        UIImageView *branImageView = [[UIImageView alloc] initWithImage:bran];
                        UIImage *hodor = [UIImage imageNamed:@"PoseScreen2.png"];
                        
                        UIGraphicsBeginImageContextWithOptions(branImageView.frame.size, NO, 1.0);
                        [[UIBezierPath bezierPathWithRoundedRect:branImageView.bounds cornerRadius:10.0] addClip];
                        [bran drawInRect:branImageView.bounds];
                        UIImage *roundedBran = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        CGSize screenSize = self.view.frame.size;
                        UIGraphicsBeginImageContext(screenSize);
                        [hodor drawInRect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
                        [roundedBran drawInRect:CGRectMake(BRAN_X + 5, BRAN_Y - 21, BRAN_WIDTH - 10, BRAN_HEIGHT + 30)];
                        UIImage *branAndHodor = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();

                        NSDictionary *params = @{
                            @"source" :  branAndHodor,
                            @"message" : @"Me and Hodor!",
                        };
                        
                        [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            UIAlertView *alertView = [[UIAlertView alloc]
                                                      initWithTitle:@"Hodor!"
                                                      message:@"Thanks for sharing!"
                                                      delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil
                                                      ];
                            [alertView show];
                        }];
                    }
                }];
                    
                break;
            }
        case 2:
            break;
        default:
            break;
    }
}

@end