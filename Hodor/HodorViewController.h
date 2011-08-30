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
    UIButton *button;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    MPMoviePlayerController *moviePlayerController;
    NSTimer *levelTimer;
    UIImageView *animatedImages;
    
    double lowPassResults;
    bool listening;
}

@property (nonatomic) bool listening;
@property (nonatomic, retain) UIImageView *animatedImages;
@property (nonatomic, retain) NSTimer *levelTimer;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (void)hodor;
- (void)sayHodor;
- (void)animateMouth;
- (void)levelTimerCallback:(NSTimer *)timer;

@end