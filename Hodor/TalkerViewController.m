//
//  TalkerViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TalkerViewController.h"
#import "HodorAppDelegate.h"

@implementation TalkerViewController

@synthesize player;

- (IBAction)backButtonPressed:(id)sender {
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app pauseListening];

    [super backButtonPressed:sender];
}

- (IBAction)hodorPressed:(id)sender {
    [self hodor];
}

- (void)hodor {
    [self animateMouth];
    [self sayHodor];
}

- (void)animateMouth {
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];

    [app.animatedImages stopAnimating];
    [app.animatedImages startAnimating];    
}

- (void)sayHodor {
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hodor%d.mp3", [[NSBundle mainBundle] resourcePath], arc4random() % NUMBER_OF_HODOR_SOUNDS]];
    
    AVAudioPlayer *newPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [self setPlayer:newPlayer];
    [newPlayer release];
    
    [self.player setDelegate:self];
    [self.player setVolume:1.0f];
    [self.player stop];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app levelTimerCallback:timer];
}

- (void)dealloc {
    [player release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view addSubview:app.animatedImages];
    
    [app beginListening];    
}

@end