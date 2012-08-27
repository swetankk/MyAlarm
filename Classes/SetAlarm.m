//
//  SetAlarm.m
//  iTalkAlarm
//
//  Created by ugsw on 30/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SetAlarm.h"
#import "AlarmRepeat.h"


@implementation SetAlarm
@synthesize tableView,arrayAlarm,dateTimePicker;
@synthesize scheduleControl;



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
//- (id)init {
//    self = [super init];
//    if(self != nil) {
//        self.deviceToken = @"6240d771c9a0778e92aa9a3e5dd712e20ec263adf25ba8b6635eac5d8969e5d9";
//		
//        self.payload = @"{\"aps\":{\"alert\":\"You got a new alarm message!\",\"badge\":5,\"sound\":\"Blow.aiff\"},\"acme1\":\"bar\",\"acme2\":42}";
//		
//        self.certificate = [[NSBundle mainBundle] 
//							pathForResource:@"aps_development" ofType:@"cer"];
//    }
//    return self;
//}//
//

-(void)viewWillAppear:(BOOL)animated
{
	
	
	
	[self.tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	tableView.clipsToBounds = YES;
	tableView.layer.cornerRadius = 10;

	tableView.layer.borderWidth = 2.0;
	tableView.layer.borderColor = [UIColor blackColor].CGColor;
	
	arrayAlarm=[[NSMutableArray alloc]init];
	[arrayAlarm addObject:@"Repeat"];
	[arrayAlarm addObject:@"Sound"];
	[arrayAlarm addObject:@"Snooze"];
	[arrayAlarm addObject:@"Label"];
	
	dateTimePicker.date=[NSDate date];
	scheduleControl.hidden=YES;
	
}


-(void) presentMessage :(NSString *)message
{
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alarm Clock" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}





-(void)addNewNotification{
	
	iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication]delegate];
	
	UILocalNotification* localNotification = [[UILocalNotification alloc] init];               
	localNotification.alertBody =@"HI";
	localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5*60];
	localNotification.timeZone = [NSTimeZone localTimeZone];
	localNotification.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber+1;
	//localNotification.soundName = UILocalNotificationDefaultSoundName;
	if(ap.intrecord==1)
	{
		//AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithData:ap.audio error:nil];
		//[avPlayer prepareToPlay];
		//[avPlayer play];
		
		//ap.intrecord=2;
		
	}
	else {
		localNotification.soundName=ap.strAlarmSound;
	}
	
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	[localNotification release];
	NSLog(@"%@",[[UIApplication sharedApplication] scheduledLocalNotifications]);
}





- (void)showReminder:(NSString *)text
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" 
														message:text delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:@"stop",@"Snooze",nil];
	[alertView show];
	[alertView release];
	
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

NSString *title = [alertView buttonTitleAtIndex:buttonIndex]; 

	NSLog(@"%@",title);
	if(buttonIndex == 0)  
	{  
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
		NSLog(@"Button 1 was selected.");  
	}  
	else if([title isEqualToString:@"Snooze"])  
	{  
		[self addNewNotification];
	}



}



-(void) scheduleLocalNotificationWithDate:(NSDate *)fireDate
{
	iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication]delegate];

	UILocalNotification *notification =[[UILocalNotification alloc]init];
	
	notification.fireDate=fireDate;
	notification.alertBody=ap.strAlarmTitle;
	notification.repeatInterval    = 0;
	notification.alertAction       = NSLocalizedString(@"View", @"View");
//notification.soundName = UILocalNotificationDefaultSoundName;
//	notification.soundName =@"Frog.aiff";

	
	
	if(ap.intrecord==1)
	{
		

		
		
		//AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:ap.audio error:nil];
//
//		
//		
//		
//		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//		[[AVAudioSession sharedInstance] setActive: YES error: nil];
//		[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//		
//		[audioPlayer play];
		
		
	NSLog(@"in rec...%@",ap.strRecordPath);	
	//notification.soundName=[NSString stringWithFormat:@"/Documents/%@",ap.strAlarmSound];	
		
		notification.soundName=ap.strRecordPath;
		
		
		//ap.intrecord=2;
		
	}
	else {
		NSLog(@"in notification...%@",ap.strAlarmSound);
		notification.soundName=ap.strAlarmSound;
		
	}

	
	
	
	
	
	
	[ap.arrAlarmName addObject:ap.strAlarmTitle];
	[ap.arrAlarmTime addObject:ap.strAlarmTime];
	
	
	
	
	
	NSInteger index =	ap.segmentValue;// [scheduleControl selectedSegmentIndex];
	switch (index) {
		case 1:
			notification.repeatInterval = NSMinuteCalendarUnit;
		
			break;
		case 2:
			notification.repeatInterval = NSHourCalendarUnit;
			break;
		case 3:
			notification.repeatInterval = NSDayCalendarUnit;
			break;
		case 4:
			notification.repeatInterval = NSWeekCalendarUnit;
			break;
		default:
			notification.repeatInterval = 0;
			break;
	}
	
	NSDictionary *userDict = [NSDictionary dictionaryWithObject:ap.strAlarmTitle
														 forKey:kRemindMeNotificationDataKey];
	notification.userInfo = userDict;
	
	
	
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	[notification release];
	
}

-(IBAction)alarmSetButtonTapped:(id)sender
{
	//NSLog(@"alarm set button tapped");
	iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication] delegate];
	
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
	//dateFormatter.timeZone=[NSLocale defaultTimeZone];
	dateFormatter.locale = [NSLocale systemLocale];
	dateFormatter.timeStyle =NSDateFormatterShortStyle;
	dateFormatter.dateStyle=NSDateFormatterShortStyle;
	
	NSString *dateTimeString=[dateFormatter stringFromDate:dateTimePicker.date];
	NSLog(@"date>>>>>%@",dateTimeString);
	ap.strAlarmTime=dateTimeString;
	
	
	[dateFormatter release];
	
	[self scheduleLocalNotificationWithDate:dateTimePicker.date];
	
	[self presentMessage:@"Alarm set!"];
	


}
-(IBAction)alarmCancelButtonTapped:(id)sender
{
	NSLog(@"alarm cancel button tapped");
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	[self presentMessage:@"Alarm Cancelled!"];

	
}



-(IBAction)btnRecord_Clicked
{
	RecordVoice *record=[[RecordVoice alloc]init];
	
	record.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:record animated:NO];
	
	
	
}

-(IBAction)btnViewAlarm_Clicked
{
	
	ViewAlarm *viewAlarm=[[ViewAlarm alloc]init];
	
	viewAlarm.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:viewAlarm animated:NO];
	
	
	
}

/*
// When the user taps Done, invokes the delegate's method that dismisses the table view.
- (IBAction) doneShowingMusicList: (id) sender {
	
	[self.delegate musicTableViewControllerDidFinish: self];	
}


// Configures and displays the media item picker.
- (IBAction) showMediaPicker: (id) sender {
	
	MPMediaPickerController *picker =
	[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
	
	[self presentModalViewController: picker animated: YES];
	[picker release];
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
	
	[self dismissModalViewControllerAnimated: YES];
	[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
	[self.tableView reloadData];
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
	
	[self dismissModalViewControllerAnimated: YES];
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}
*/


#pragma mark Table view methods________________________

// To learn about using table views, see the TableViewSuite sample code  
//		and Table View Programming Guide for iPhone OS.

- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section {
	
//	RecordVoice *mainViewController = (RecordVoice *) self.delegate;
//	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	return [arrayAlarm count];//[currentQueue.items count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView1 cellForRowAtIndexPath: (NSIndexPath *) indexPath {
	
	static NSString *kCellIdentifier = @"Cell";

	iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication] delegate];
	
	NSInteger row = [indexPath row];
	CustomAlarmTable *cell =(CustomAlarmTable *) [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	
	if (cell == nil) {
		
		cell = [[[CustomAlarmTable alloc] initWithFrame: CGRectZero 
									   reuseIdentifier: kCellIdentifier] autorelease];
	}
	
//	RecordVoice  *mainViewController = (RecordVoice *) self.delegate;
//	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
//	MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: row];
	
	//if (anItem) {
	cell.lblCategoryName.text = [arrayAlarm objectAtIndex:row];
	
	if(row==1)
		cell.lblPicked.text = ap.strSoundName;
	
	if(row==3)
	{
	cell.lblPicked.text = ap.strAlarmTitle;
	}
	
	//[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	return cell;
}

//	 To conform to the Human Interface Guidelines, selections should not be persistent --
//	 deselect the row after it has been selected.
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	
	
	if(indexPath.row==0)
	{
		 
		//scheduleControl.hidden=NO;
		//tableView.hidden=YES;
		
		AlarmRepeat *repeat=[[AlarmRepeat alloc]init];
		repeat.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		[self presentModalViewController:repeat animated:YES];  
		
		
	}
	
	
	if(indexPath.row==1)
	{
		setSound *sound=[[setSound alloc]init];
		
		sound.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		[self presentModalViewController:sound animated:YES];  
		
		
	}//[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	
	if(indexPath.row==3)
	{
		setLabel *lbl=[[setLabel alloc]init];
	
		lbl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		[self presentModalViewController:lbl animated:YES];  
	
	
	}
	
	
}


#pragma mark -
#pragma mark Navigation Controller delegate


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
