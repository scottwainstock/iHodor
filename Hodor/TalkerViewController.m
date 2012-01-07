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

@synthesize player, animatedImages;

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
    [self.animatedImages stopAnimating];
    [self.animatedImages startAnimating];    
}

- (void)sayHodor {
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hodor%d.mp3", [[NSBundle mainBundle] resourcePath], arc4random() %2]];
    
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
    HodorAppDelegate *app = (HodorAppDelegate *) [[UIApplication sharedApplication] delegate];
    [app levelTimerCallback:timer];
}

- (void)dealloc {
    [animatedImages release];
    [player release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
    for (int i = 0; i < IMAGE_COUNT; i++)
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mouth%d.png", i]]];
    
    self.animatedImages = [[UIImageView alloc] initWithFrame:CGRectMake(
        ([UIScreen mainScreen].bounds.size.width / 2) - (IMAGE_WIDTH / 2), 
        ([UIScreen mainScreen].bounds.size.height / 2) - (IMAGE_HEIGHT /2) + HEIGHT_OFFSET,
        IMAGE_WIDTH, IMAGE_HEIGHT
    )];
    [self.animatedImages setAnimationImages:[NSArray arrayWithArray:imageArray]];
    [self.animatedImages setAnimationDuration:0.5];
    [self.animatedImages setAnimationRepeatCount:1];
    [self.animatedImages setImage:[imageArray objectAtIndex:0]];
    [self.view addSubview:self.animatedImages];
    
    HodorAppDelegate *app = (HodorAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app beginListening];
    
    [imageArray release];
}

@end