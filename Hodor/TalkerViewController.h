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
#import "HodorViewController.h"

#define NUMBER_OF_HODOR_SOUNDS 10

@interface TalkerViewController : HodorViewController <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
}

@property(nonatomic, retain) AVAudioPlayer *player;

- (void)hodor;
- (void)animateMouth;
- (void)sayHodor;

- (IBAction)hodorPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end