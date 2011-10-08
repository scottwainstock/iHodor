//
//  HodorAppDelegate.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorAppDelegate.h"
#import "HodorViewController.h"
#import "TalkerViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <CoreAudio/CoreAudioTypes.h>

#define ALPHA 0.05

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
    
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
    
	NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    if (lowPassResults > 0.20) {
        listening = TRUE;
    }
    
    TalkerViewController *talkerViewController = nil;
    for (id controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TalkerViewController class]]) {
            talkerViewController = controller;
        }
    }
    
    if ((talkerViewController != nil) && (listening == TRUE) && (lowPassResults < 0.20)) {
        [talkerViewController hodor];
        listening = FALSE;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    sleep(1);
    
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
  		recorder.meteringEnabled = YES;
  	} else {
  		NSLog(@"ERROR: %@", [error description]);
    }

    navigationController = [[UINavigationController alloc] init];
    [navigationController setNavigationBarHidden:YES];
    [navigationController setToolbarHidden:YES];
    [navigationController setHidesBottomBarWhenPushed:YES];
    
    [navigationController pushViewController:self.viewController animated:YES];
    self.window.rootViewController = self.viewController;
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [levelTimer invalidate];
    [recorder pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    
    [recorder record];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
    [levelTimer release];
    [recorder release];
    [_window release];
    [_viewController release];
    [navigationController release];
    [super dealloc];
}

@end