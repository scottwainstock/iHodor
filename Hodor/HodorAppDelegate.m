//
//  HodorAppDelegate.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorAppDelegate.h"
#import "TalkerViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioServices.h>

@implementation HodorAppDelegate

@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize player, recorder, navigationController, levelTimer, listening, animatedImages;

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

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	double peakPowerForChannel = pow(10, (ALPHA * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
    
	//NSLog(@"Low pass results: %f", lowPassResults);
    if (lowPassResults > MINIMUM_LOW_PASS_LEVEL)
        listening = TRUE;
    
    TalkerViewController *talkerViewController = nil;
    if ([[self.navigationController visibleViewController] isKindOfClass:[TalkerViewController class]])
        talkerViewController = (TalkerViewController *)[self.navigationController visibleViewController];
    
    if ((talkerViewController != nil) && (listening == TRUE) && (lowPassResults < MINIMUM_LOW_PASS_LEVEL)) {
        [self hodor];
        listening = FALSE;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"recordedSound.%@", @"caf"]]];
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithFloat:44100.0],                 AVSampleRateKey,
        [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey,
        [NSNumber numberWithInt:1],                         AVNumberOfChannelsKey,
        [NSNumber numberWithInt:AVAudioQualityMax],         AVEncoderAudioQualityKey,
        nil
    ];
    
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
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < MOUTH_ANIMATION_IMAGE_COUNT; i++)
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mouth%d.png", i]]];
    
    self.animatedImages = [[UIImageView alloc] initWithFrame:CGRectMake(
        ([UIScreen mainScreen].bounds.size.width / 2) - (IMAGE_WIDTH / 2), 
        ([UIScreen mainScreen].bounds.size.height / 2) - (IMAGE_HEIGHT /2) + HEIGHT_OFFSET,
        IMAGE_WIDTH, IMAGE_HEIGHT
    )];
    [self.animatedImages setAnimationImages:[NSArray arrayWithArray:imageArray]];
    [self.animatedImages setAnimationDuration:0.5];
    [self.animatedImages setAnimationRepeatCount:1];
    [self.animatedImages setImage:[imageArray objectAtIndex:0]];
    
    [imageArray release];
    
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

- (void)sayHodor {    
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

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[self.navigationController visibleViewController] isKindOfClass:[TalkerViewController class]])
        [self beginListening];
}

- (void)dealloc {
    [animatedImages release];
    [levelTimer release];
    [recorder release];
    [player release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
