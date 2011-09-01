//
//  HodorAppDelegate.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorAppDelegate.h"
#import "HodorViewController.h"

#define ALPHA 0.05

@implementation HodorAppDelegate

@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize recorder, listening, levelTimer;

- (AVAudioRecorder *)recorder {
    @synchronized(recorder) {
        if (recorder == nil)
            recorder = [[AVAudioRecorder alloc] init];
        return recorder;
    }
    
    return nil;
}

- (NSTimer *)levelTimer {
    @synchronized(levelTimer) {
        if (levelTimer == nil)
            levelTimer = [[NSTimer alloc] init];
        return levelTimer;
    }
    return nil;
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[recorder updateMeters];
    
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
    
	//NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    if (lowPassResults > 0.20) {
        listening = TRUE;
    }
    
    if ((listening == TRUE) && (lowPassResults < 0.20)) {
        [(HodorViewController *)self.window.rootViewController hodor];
        listening = FALSE;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    sleep(1);

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
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
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
    
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (recorder) {
  		[recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
  		[recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
  	} else {
  		NSLog(@"ERROR: %@", [error description]);
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [recorder pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [recorder record];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc
{
    [levelTimer release];
    [recorder release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end