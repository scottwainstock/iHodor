//
//  HodorViewController.h
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HodorViewController : UIViewController <AVAudioPlayerDelegate> {
    UIButton *hodor;
    AVAudioRecorder *recorder;
    MPMoviePlayerController *moviePlayerController;
    NSTimer *levelTimer;
    double lowPassResults;
}

@property (nonatomic, retain) IBOutlet UIButton *hodor;

- (void)sayHodor;
- (void)levelTimerCallback:(NSTimer *)timer;

@end
