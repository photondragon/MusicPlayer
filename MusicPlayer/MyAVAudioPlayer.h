//
//  MyAVAudioPlayer.h
//  MusicPlayer
//
//  Created by mahj on 11/7/13.
//  Copyright (c) 2013年 photondragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundPlayerProtocol.h"

//用AVAudioPlayer来实现SoundPlayerProtocol
@interface MyAVAudioPlayer : NSObject
<SoundPlayerProtocol>

@end
