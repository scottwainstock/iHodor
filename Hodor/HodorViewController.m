//
//  HodorViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorViewController.h"

@implementation HodorViewController

@synthesize hodor;

AVAudioPlayer *hodorPlayer;

- (void)dealloc {
    [hodor release];
    [levelTimer release];
    [recorder release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [hodor addTarget:self action:@selector(sayHodor) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *hodorPath = [[NSBundle mainBundle] pathForResource:@"hodor" ofType:@"wav"];
    
    hodorPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:hodorPath] error:NULL];
    
    hodorPlayer.delegate = self;
    [hodorPlayer prepareToPlay];
    
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
    
	const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;	
    
	//NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    if (lowPassResults > 0.20)
		[self sayHodor];
}

- (void)sayHodor {
    [hodorPlayer play];
}

- (void)viewDidUnload {
    [self setHodor:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end