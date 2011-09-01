//
//  HodorAppDelegate.h
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>

@class HodorViewController;

@interface HodorAppDelegate : NSObject <UIApplicationDelegate> {
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    
    bool listening;
    double lowPassResults;
}

@property (nonatomic) bool listening;
@property (nonatomic, retain) NSTimer *levelTimer;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HodorViewController *viewController;

- (void)levelTimerCallback:(NSTimer *)timer;

@end