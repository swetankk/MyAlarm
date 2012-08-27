//
//  iTalkAlarmAppDelegate.h
//  iTalkAlarm
//
//  Created by ugsw on 30/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "SetAlarm.h"

@class MainView;

@interface iTalkAlarmAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MainView *mainView;
	NSString *strAlarmTitle;
	NSString *strAlarmTime;
	NSString *strAlarmSound;
	NSString *strSoundName;
	NSString *strRepeatName;
	NSString *strRecordPath;
	NSMutableArray *arrAlarmName,*arrAlarmTime ;
	NSArray *arrRecorded;
	NSData *audio;
	int selectrow,segmentValue,repeatRow,intrecord;
	
	NSString *deviceToken;
	NSString *payload;
	NSString *certificate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) MainView *mainView;
@property (nonatomic, retain) IBOutlet UINavigationController *nav;

@property(nonatomic,retain)NSString *strAlarmTitle;
@property(nonatomic,retain)NSString *strAlarmTime;
@property(nonatomic,retain)NSString *strAlarmSound;
@property(nonatomic,retain)NSString *strSoundName,*strRepeatName;
@property(nonatomic,assign)int selectrow,segmentValue,repeatRow,intrecord;
@property(nonatomic,retain)NSMutableArray *arrAlarmName,*arrAlarmTime;
@property(nonatomic,retain)NSArray *arrRecorded;
@property(nonatomic,retain)NSData *audio;
@property(nonatomic,retain)NSString *strRecordPath;
@property(nonatomic,retain)NSString *deviceToken;
@property(nonatomic,retain)NSString *payload;
@property(nonatomic,retain)NSString *certificate;


extern NSString *kRemindMeNotificationDataKey;

@end

