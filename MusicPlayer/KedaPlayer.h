//
//  KedaPlayer.h
//  MusicPlayer
//
//  Created by mahj on 12/7/13.
//  Copyright (c) 2013年 photondragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundPlayerProtocol.h"

@interface KedaPlayer : NSObject
<SoundPlayerProtocol>
{
	BOOL isStopping;
}

@end
