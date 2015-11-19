//
//  ViewController.h
//  MusicPlayer
//
//  Created by mahj on 11/7/13.
//  Copyright (c) 2013年 photondragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundPlayerProtocol.h"

@interface ViewController : UIViewController
<SoundPlayerDelegate>
{
	id<SoundPlayerProtocol> soundPlayer;
}
@property (nonatomic,assign) IBOutlet UIButton* btnPlay;
@property (nonatomic,assign) IBOutlet UIButton* btnPause;
@property (nonatomic,assign) IBOutlet UIButton* btnStop;
-(IBAction)btnPlayClicked:(id)sender;
-(IBAction)btnPauseClicked:(id)sender;
-(IBAction)btnStopClicked:(id)sender;
@end
