#import "HodorAppDelegate.h"
#import "TalkerViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioServices.h>

#define NSLog TFLog

@implementation HodorAppDelegate

@synthesize window=_window, viewController=_viewController, player, recorder, navigationController, levelTimer, listening, talking, animatedImages, mainMenuViewController;

- (NSTimer *)levelTimer {
    @synchronized(levelTimer) {
        if (levelTimer == nil)
            levelTimer = [[NSTimer alloc] init];
        return levelTimer;
    }
    
    return nil;
}

- (AVAudioPlayer *)player {
    @synchronized(player) {
        if (player == nil)
            player = [[AVAudioPlayer alloc] init];
        return player;
    }
    
    return nil;
}

- (AVAudioRecorder *)recorder {
    @synchronized(recorder) {
        if (recorder == nil)
            recorder = [[AVAudioRecorder alloc] init];
        return recorder;
    }
    
    return nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    talking = false;
    [self beginListening];
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	double peakPowerForChannel = pow(10, (ALPHA * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
    
    if (lowPassResults > MINIMUM_LOW_PASS_LEVEL)
        listening = TRUE;
        
    TalkerViewController *talkerViewController = nil;
    if ([[self.navigationController visibleViewController] isKindOfClass:[TalkerViewController class]])
        talkerViewController = (TalkerViewController *)[self.navigationController visibleViewController];
    
    if ((talkerViewController != nil) && listening && (lowPassResults < MINIMUM_LOW_PASS_LEVEL)) {
        [self hodor];
        listening = FALSE;
        lowPassResults = 0.0f;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TestFlight takeOff:@"1490ac07669932a8fe9d25f54c3ef63e_OTQwNTIyMDEyLTA1LTI3IDAxOjUzOjA3LjA4OTYzMg"];

    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"recordedSound.%@", @"caf"]]];
  	NSDictionary *settings = @{AVSampleRateKey: @44100.0f,
        AVFormatIDKey: @(kAudioFormatAppleLossless),
        AVNumberOfChannelsKey: @1,
        AVEncoderAudioQualityKey: @(AVAudioQualityMax)};
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:[audioSession inputIsAvailable] ? AVAudioSessionCategoryPlayAndRecord : AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:YES error:nil];
    [audioSession setDelegate:self];
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);

  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    
  	if (recorder) {
  		[recorder prepareToRecord];
  		[recorder setMeteringEnabled:YES];
        
        //start and then immediately pause to push off weird slowdown issue to app initialization
        [recorder record];
        [recorder pause];
  	}
    
    navigationController = [[UINavigationController alloc] init];
    [navigationController setNavigationBarHidden:YES];
    [navigationController setToolbarHidden:YES];
    [navigationController setHidesBottomBarWhenPushed:YES];
    
    [navigationController pushViewController:self.viewController animated:YES];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
        
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}

- (void)initializeMouthWithImages:(NSMutableArray *)images dimensions:(CGRect)dimensions {   
    self.animatedImages = [[UIImageView alloc] initWithFrame:dimensions];
    
    [self.animatedImages setAnimationImages:[NSArray arrayWithArray:images]];
    [self.animatedImages setAnimationDuration:0.5];
    [self.animatedImages setAnimationRepeatCount:1];
    [self.animatedImages setImage:[images objectAtIndex:0]];
    
}

- (void)sayHodor {
    [self pauseListening];

    NSString *soundFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"hodor%d", arc4random() % NUMBER_OF_HODOR_SOUNDS] ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:soundFile];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
        
    [player setDelegate:self];
    [player stop];
    [player prepareToPlay];
    [player play];
}

- (void)beginListening {
    levelTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    [recorder record];
}

- (void)pauseListening {
    [levelTimer invalidate];
    [recorder pause];
}

- (void)hodor {
    if (talking)
        return;
    
    talking = true;
    [self animateMouth];
    [self sayHodor];
}

- (void)animateMouth {
    [self.animatedImages stopAnimating];
    [self.animatedImages startAnimating];    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    if (
        [[self.navigationController visibleViewController] isKindOfClass:[TalkerViewController class]] &&
        [levelTimer isValid]
    )
        [self pauseListening];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([[self.navigationController visibleViewController] isKindOfClass:[TalkerViewController class]])
        [self beginListening];
}


@end
