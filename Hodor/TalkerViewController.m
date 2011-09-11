//
//  TalkerViewController.m
//  Hodor
//
//  Created by Scott Wainstock on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TalkerViewController.h"

#define IMAGE_COUNT   15
#define IMAGE_WIDTH   175
#define IMAGE_HEIGHT  65
#define HEIGHT_OFFSET 55

@implementation TalkerViewController

@synthesize player, animatedImages;

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    self.player = newPlayer;
    [newPlayer release];
    
    self.player.delegate = self;
    self.player.volume = 1.0f;
    [self.player stop];
    [self.player prepareToPlay];
    [self.player play];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [animatedImages release];
    [player release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:IMAGE_COUNT];
    
    for (int i = 0; i < IMAGE_COUNT; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"mouth%d.png", i]]];
    }
    
    self.animatedImages = [[UIImageView alloc] initWithFrame:CGRectMake(
        ([UIScreen mainScreen].bounds.size.width / 2) - (IMAGE_WIDTH / 2), 
        ([UIScreen mainScreen].bounds.size.height / 2) - (IMAGE_HEIGHT /2) + HEIGHT_OFFSET,
        IMAGE_WIDTH, IMAGE_HEIGHT
    )];
    self.animatedImages.animationImages = [NSArray arrayWithArray:imageArray];
    self.animatedImages.animationDuration = 0.5;
    self.animatedImages.animationRepeatCount = 1;
    self.animatedImages.image = [imageArray objectAtIndex:0];
    [self.view addSubview:self.animatedImages];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setAnimatedImages:nil];
    [self setPlayer:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end