//
//  ViewController.m
//  MusicPlayer
//
//  Created by mahj on 11/7/13.
//  Copyright (c) 2013年 photondragon. All rights reserved.
//

#import "ViewController.h"
#import "MyAVAudioPlayer.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize btnPlay;
@synthesize btnPause;
@synthesize btnStop;

-(void)dealloc
{
	[soundPlayer release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSString* filename = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
	soundPlayer = [[MyAVAudioPlayer alloc] init];
	soundPlayer.delegate = self;
	[soundPlayer load:filename];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnPlayClicked:(id)sender
{
	[soundPlayer play];
}
-(IBAction)btnPauseClicked:(id)sender
{
	[soundPlayer pause];
}
-(IBAction)btnStopClicked:(id)sender
{
	[soundPlayer stop];
}

#pragma mark SoundPlayerDelegate
-(void)soundPlayer:(id<SoundPlayerProtocol>)player enterState:(ESoundPlayStates)newState oldState:(ESoundPlayStates)oldState
{
	switch(newState)
	{
		case ESoundStateNone:
			NSLog(@"Sound None");
			break;
		case ESoundStateLoading:
			NSLog(@"Sound Loading");
			break;
		case ESoundStatePlaying:
			NSLog(@"Sound Playing");
			break;
		case ESoundStatePaused:
			NSLog(@"Sound Paused");
			break;
		case ESoundStateStopped:
			NSLog(@"Sound Stopped");
			break;
		case ESoundStateFailed:
			NSLog(@"Sound Failed");
			break;
		default:
			break;
	}
}
-(void) soundPlayer:(id<SoundPlayerProtocol>)player progress:(double)currentTime
{
	NSLog(@"%%%.0f",currentTime/player.totalTime*100.0);
}
@end
