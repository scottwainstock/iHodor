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
@synthesize recorder, listening, levelTimer, navigationController;

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
        //[(HodorViewController *)self.window.rootViewController hodor];
        listening = FALSE;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    sleep(1);

    navigationController = [[UINavigationController alloc] init];
    [navigationController setNavigationBarHidden:YES];
    [navigationController setToolbarHidden:YES];
    
    [navigationController pushViewController:self.viewController animated:YES];
    self.window.rootViewController = self.viewController;
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
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
    [navigationController release];
    [super dealloc];
}

@end