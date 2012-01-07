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

@implementation HodorAppDelegate

@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize recorder, navigationController, levelTimer, listening;

- (NSTimer *)levelTimer {
    @synchronized(levelTimer) {
        if (levelTimer == nil)
            levelTimer = [[NSTimer alloc] init];
        return levelTimer;
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
        [talkerViewController hodor];
        listening = FALSE;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {     
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"recordedSound.%@", @"caf"]]];
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 
                              AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], 
                              AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                       
                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],        
                              AVEncoderAudioQualityKey,
                              nil];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
    
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (recorder) {
  		[recorder prepareToRecord];
  		[recorder setMeteringEnabled:YES];
  	}

    navigationController = [[UINavigationController alloc] init];
    [navigationController setNavigationBarHidden:YES];
    [navigationController setToolbarHidden:YES];
    [navigationController setHidesBottomBarWhenPushed:YES];
    
    [navigationController pushViewController:self.viewController animated:YES];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    return YES;
}

- (void)beginListening {
    levelTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    [recorder record];
}

- (void)pauseListening {
    [levelTimer invalidate];
    [recorder pause];
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
    [levelTimer release];
    [recorder release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
