//
//  TalkerViewController.h
//  Hodor
//
//  Created by Scott Wainstock on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#define IMAGE_COUNT   15
#define IMAGE_WIDTH   175
#define IMAGE_HEIGHT  65
#define HEIGHT_OFFSET 50

@interface TalkerViewController : UIViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    UIImageView *animatedImages;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) UIImageView *animatedImages;

- (void)hodor;
- (void)animateMouth;
- (void)sayHodor;

- (IBAction)hodorPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end