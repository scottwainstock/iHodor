//
//  HodorAppDelegate.h
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>

#define TIMER_INTERVAL 0.01
#define ALPHA 0.05
#define ISCAB_URL @"http://itunes.apple.com/us/app/iscab/id480510644?ls=1&mt=8"

@interface HodorAppDelegate : NSObject <UIApplicationDelegate> {
    NSTimer *levelTimer;
    AVAudioRecorder *recorder;
    UINavigationController *navigationController;
    
    bool listening;
    double lowPassResults;
}

@property(nonatomic) bool listening;
@property(nonatomic, retain) NSTimer *levelTimer;
@property(nonatomic, retain) AVAudioRecorder *recorder;
@property(nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property(nonatomic, retain) IBOutlet UIWindow *window;

- (void)levelTimerCallback:(NSTimer *)timer;
- (void)beginListening;
- (void)pauseListening;

@end