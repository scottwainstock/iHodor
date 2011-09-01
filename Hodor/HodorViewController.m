//
//  HodorViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HodorViewController.h"

#define IMAGE_COUNT   15
#define IMAGE_WIDTH   180
#define IMAGE_HEIGHT  70
#define HEIGHT_OFFSET 60
#define SCREEN_HEIGHT 460
#define SCREEN_WIDTH  320

@implementation HodorViewController

@synthesize button, player, animatedImages;

- (void)dealloc {
    [animatedImages release];
    [button release];
    [player release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //[button addTarget:self action:@selector(hodor) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(hodor) forControlEvents:UIControlEventTouchDown];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
    
    for (int i = 0; i < IMAGE_COUNT; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mouth%d.png", i]]];
    }

    self.animatedImages = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                        (SCREEN_WIDTH / 2) - (IMAGE_WIDTH / 2), 
                                                        (SCREEN_HEIGHT / 2) - (IMAGE_HEIGHT /2) + HEIGHT_OFFSET,
                                                        IMAGE_WIDTH, IMAGE_HEIGHT)];
    self.animatedImages.animationImages = [NSArray arrayWithArray:imageArray];
    self.animatedImages.animationDuration = 0.5;
    self.animatedImages.animationRepeatCount = 1;
    self.animatedImages.image = [imageArray objectAtIndex:0];
    [self.view addSubview:self.animatedImages];
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
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end