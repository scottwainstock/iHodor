//
//  HodorViewController.h
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <MediaPlayer/MediaPlayer.h>


@interface HodorViewController : UIViewController <AVAudioPlayerDelegate> {
    UIButton *button;
    AVAudioPlayer *player;
    MPMoviePlayerController *moviePlayerController;
    UIImageView *animatedImages;    
}

@property (nonatomic, retain) UIImageView *animatedImages;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (void)hodor;
- (void)animateMouth;
- (void)sayHodor;

@end