//
//  SoundPlayerProtocol.h
//  MusicPlayer
//
//  Created by mahj on 11/7/13.
//  Copyright (c) 2013年 photondragon. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _ABCDHello_SoundPlayerProtocol_H_
#define _ABCDHello_SoundPlayerProtocol_H_

/// 声音播放状态
typedef enum _ESoundPlayState
{//加载成功后可以进入Stopped状态，也可以直接进入Playing状态，这看具体怎么实现，没有强制要求
	ESoundStateNone=0,//未加载
	ESoundStateLoading,//正在加载
	ESoundStateFailed,//出错了
	ESoundStatePlaying,//正在播放
	ESoundStatePaused,//暂停
	ESoundStateStopped,//停止
}ESoundPlayStates;

/// 声音播放器委托
@protocol SoundPlayerDelegate;

/// 音频播放器接口
@protocol SoundPlayerProtocol <NSObject>
- (void)load:(NSString*)soundfile;//加载音频文件
- (void)unload;//卸载音频文件
- (void)play;
- (void)pause;
- (void)stop;
@property (nonatomic,retain) id<SoundPlayerDelegate> delegate;
@property (nonatomic,assign) ESoundPlayStates soundState;
@property (nonatomic,assign) double currentTime;//当前播放位置（时间）
@property (nonatomic,assign,readonly) double totalTime;//总时长
@end

/// 声音播放器委托
@protocol SoundPlayerDelegate <NSObject>
@optional
/// 通知状态变化
- (void)soundPlayer:(id<SoundPlayerProtocol>)player enterState:(ESoundPlayStates)newState oldState:(ESoundPlayStates)oldState;
/// 通知进度变化
- (void)soundPlayer:(id<SoundPlayerProtocol>)player progress:(double)currentTime;
@end

/*
 假设MyAVAudioPlayer、OpenALPlayer、ThirdPartSoundPlayer都实现了SoundPlayerProtocol接口。
 如果你想让你的程序用AVAudio播放声音，就生成一个MyAVAudioPlayer对象：
 id<SoundPlayerProtocol> player = [[MyAVAudioPlayer alloc] init];
 如果你想让你的程序用OpenAL播放声音，就生成一个OpenALPlayer对象：
 id<SoundPlayerProtocol> player = [[OpenALPlayer alloc] init];
 如果你想让你的程序用第三方音频库播放声音，就生成一个ThirdPartSoundPlayer对象：
 id<SoundPlayerProtocol> player = [[ThirdPartSoundPlayer alloc] init];
 
 然后播放控制的代码都是一致的：
 [player play];
 [player stop];
 [player pause];
 使用者无需知道播放器对象到底是MyAVAudioPlayer对象、OpenALPlayer对象还是ThirdPartSoundPlayer对象，因为它们都是id<SoundPlayerProtocol>
*/
#endif