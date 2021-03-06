#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import "IscabAdViewController.h"
#import "TestFlight.h"
#import "HodorMainMenuViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#define NUMBER_OF_HODOR_SOUNDS 5

#define HEIGHT_OFFSET       55

#define MOUTH_ANIMATION_IMAGE_COUNT 15
#define MINIMUM_LOW_PASS_LEVEL 0.40
#define TIMER_INTERVAL 0.01
#define ALPHA 0.05

#define BRAN_WIDTH  100
#define BRAN_HEIGHT 150
#define BRAN_X      214
#define BRAN_Y      187

#define ISCAB_URL @"http://itunes.apple.com/us/app/iscab/id480510644?ls=1&mt=8"

@interface HodorAppDelegate : NSObject <UIApplicationDelegate, AVAudioSessionDelegate, AVAudioPlayerDelegate> {
    NSTimer *levelTimer;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    UINavigationController *navigationController;
    HodorMainMenuViewController *mainMenuViewController;
    UIImageView *animatedImages;

    bool talking;
    bool listening;
    double lowPassResults;
}

@property(nonatomic) bool listening;
@property(nonatomic) bool talking;
@property(nonatomic, strong) NSTimer *levelTimer;
@property(nonatomic, strong) UINavigationController *navigationController;
@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, strong) AVAudioPlayer *player;
@property(nonatomic, strong) UIImageView *animatedImages;
@property(nonatomic, strong) IBOutlet UIWindow *window;
@property(nonatomic, strong) IBOutlet IscabAdViewController *viewController;
@property(nonatomic, strong) HodorMainMenuViewController *mainMenuViewController;

- (void)levelTimerCallback:(NSTimer *)timer;
- (void)beginListening;
- (void)pauseListening;
- (void)sayHodor;
- (void)hodor;
- (void)animateMouth;
- (void)initializeMouthWithImages:(NSMutableArray *)images dimensions:(CGRect)dimensions;
- (NSString *)branFilename;

@end