//
//  MyAVAudioPlayer.m
//  MusicPlayer
//
//  Created by mahj on 11/7/13.
//  Copyright (c) 2013年 photondragon. All rights reserved.
//

#import "MyAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface MyAVAudioPlayer()
<AVAudioPlayerDelegate>
{
	AVAudioPlayer* player;
	NSTimer* updateProgressTimer;
}
@end

@implementation MyAVAudioPlayer
@synthesize delegate;
@synthesize soundState;

- (id)init
{
	self = [super init];
	if(self)
	{
		
	}
	return self;
}
- (void)dealloc
{
	if(soundState != ESoundStateNone)
	{
		[self unload];
	}
	[delegate release];
	[super dealloc];
}

- (void)notifyNewState:(ESoundPlayStates)newState oldState:(ESoundPlayStates)oldState
{
	if(oldState==newState)
		return;
	if(soundState==ESoundStatePlaying)
		updateProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
	else
	{
		if(updateProgressTimer)
		{
			[updateProgressTimer invalidate];
			updateProgressTimer = nil;
		}
	}
	if(delegate && [delegate respondsToSelector:@selector(soundPlayer:enterState:oldState:)])
		[delegate soundPlayer:self enterState:soundState oldState:ESoundStateNone];
}
- (void)notifyProgress:(double)currentTime
{
	if(delegate && [delegate respondsToSelector:@selector(soundPlayer:progress:)])
		[delegate soundPlayer:self progress:currentTime];
}

- (void)load:(NSString*)soundfile//加载音频文件
{
	if(soundState != ESoundStateNone)
	{
		[self unload];
	}
	NSData* data = [NSData dataWithContentsOfFile:soundfile];
	if(data)
	{
		NSError* error=nil;
		player = [[AVAudioPlayer alloc] initWithData:data error:&error];
		if(player && error==nil)
		{
			player.delegate = self;
			soundState = ESoundStateStopped;
		}
		else
		{
			soundState = ESoundStateFailed;
		}
	}
	else
		soundState = ESoundStateFailed;
	[self notifyNewState:soundState oldState:ESoundStateNone];
}
- (void)unload
{
	if(soundState != ESoundStateNone)
	{
		ESoundPlayStates oldstate = soundState;
		soundState = ESoundStateNone;
		if(player)
		{
			player.delegate = nil;
			[player release];
			player = nil;
		}
		
		[self notifyNewState:soundState oldState:oldstate];
	}
	if(updateProgressTimer)
	{
		[updateProgressTimer invalidate];
		updateProgressTimer = nil;
	}
}
- (void)play
{
	if(soundState!=ESoundStateStopped && soundState!=ESoundStatePaused)
		return;
	ESoundPlayStates oldstate = soundState;
	if([player play])
		soundState = ESoundStatePlaying;
	else
		soundState = ESoundStateFailed;
	[self notifyNewState:soundState oldState:oldstate];
}
- (void)pause
{
	if(soundState!=ESoundStatePlaying)
		return;
	ESoundPlayStates oldstate = soundState;
	[player pause];
	soundState = ESoundStatePaused;
	[self notifyNewState:soundState oldState:oldstate];
}
- (void)stop
{
	if(soundState!=ESoundStatePlaying && soundState!=ESoundStatePaused)
		return;
	ESoundPlayStates oldstate = soundState;
	[player stop];
	self.currentTime = 0.0;
	soundState = ESoundStateStopped;
	[self notifyNewState:soundState oldState:oldstate];
}

- (double)totalTime
{
	return player.duration;
}
- (double)currentTime
{
	return player.currentTime;
}
- (void)setCurrentTime:(double)currentTime
{
	player.currentTime = currentTime;
	[self notifyProgress:player.currentTime];
}

- (void)updateProgress
{
	if(soundState!=ESoundStatePlaying)
		return;
	[self notifyProgress:player.currentTime];
}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	ESoundPlayStates oldstate = soundState;
	if(flag==TRUE)
		soundState = ESoundStateStopped;
	else//出现解码错误
		soundState = ESoundStateFailed;
	[self notifyNewState:soundState oldState:oldstate];
}

//??????未测试?????
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	ESoundPlayStates oldstate = soundState;
	soundState = ESoundStateFailed;
	[self notifyNewState:soundState oldState:oldstate];
}
//??????未测试?????
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	ESoundPlayStates oldstate = soundState;
	soundState = ESoundStatePaused;
	[self notifyNewState:soundState oldState:oldstate];
}
//??????未测试?????
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
	if(flags == AVAudioSessionInterruptionOptionShouldResume)
	{
		;
	}
	ESoundPlayStates oldstate = soundState;
	soundState = ESoundStatePlaying;
	[self notifyNewState:soundState oldState:oldstate];
}
@end
