//
//  HodorViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorViewController.h"

#define ALPHA         0.05
#define IMAGE_COUNT   15
#define IMAGE_WIDTH   240
#define IMAGE_HEIGHT  180
#define HEIGHT_OFFSET 100
#define SCREEN_HEIGHT 460
#define SCREEN_WIDTH  320

@implementation HodorViewController

@synthesize button, listening, recorder, player, levelTimer, animatedImages, mouth;

- (NSTimer *)levelTimer {
    @synchronized(levelTimer) {
        if (levelTimer == nil)
            levelTimer = [[NSTimer alloc] init];
        return levelTimer;
    }
    return nil;
}

- (AVAudioRecorder *)recorder {
    @synchronized(recorder) {
        if (recorder == nil)
            recorder = [[AVAudioRecorder alloc] init];
        return recorder;
    }
    
    return nil;
}

/*
- (AVAudioPlayer *)player {
    @synchronized(player) {
        if (player == nil)
            player = [[AVAudioPlayer alloc] init];
        return player;
    }
    
    return nil;
}
 */

- (void)dealloc {
    [animatedImages release];
    [button release];
    [levelTimer release];
    [player release];
    [recorder release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [button addTarget:self action:@selector(hodor) forControlEvents:UIControlEventTouchUpInside];
    listening = false;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
    
    for (int i = 0; i < IMAGE_COUNT; i++) [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mouth%d.png", i]]];
    
    self.animatedImages = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                            (SCREEN_WIDTH / 2) - (IMAGE_WIDTH / 2), 
                                                            (SCREEN_HEIGHT / 2) - (IMAGE_HEIGHT / 2) + HEIGHT_OFFSET,
                                                            IMAGE_WIDTH, IMAGE_HEIGHT)];
    self.animatedImages.animationImages = [NSArray arrayWithArray:imageArray];    
    self.animatedImages.animationDuration = 0.5;
    self.animatedImages.animationRepeatCount = 0;
    [self.view addSubview:self.animatedImages];

    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"]; 
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 
                              AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], 
                              AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                       
                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],        
                              AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (recorder) {
  		[recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
  		[recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];

  	} else {
  		NSLog(@"ERROR: %@", [error description]);
    }
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
        [self hodor];
        listening = FALSE;
    }
}

- (void)hodor {
    [self animateMouth];
    [self sayHodor];
}

- (void)stopAnimation {
    [self.animatedImages stopAnimating];
    [self.mouth setHidden:NO];
}

- (void)animateMouth {
    [self.mouth setHidden:YES];
    self.animatedImages.startAnimating;
    
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5];
}

- (void)sayHodor {
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hodor%d.mp3", [[NSBundle mainBundle] resourcePath], arc4random() %2]];

    AVAudioPlayer *newPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    self.player = newPlayer;
    [newPlayer release];
    
    self.player.delegate = self;
    self.player.volume = 1.0f;
    [self.player stop];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)viewDidUnload {
    [self setAnimatedImages:nil];
    [self setButton:nil];
    [self setPlayer:nil];
    [self setRecorder:nil];
    [self setLevelTimer:nil];
    [self setListening:FALSE];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end