//
//  RecordVoice.m
//  iTalkAlarm
//
//  Created by ugsw on 30/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordVoice.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation RecordVoice

@synthesize savedRecordings,cafFiles;

@synthesize deviceToken,payload,certificate;


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
- (id)init {
    self = [super init];
    if(self != nil) {
		//6240d771 c9a0778e 92aa9a3e 5dd712e2 0ec263ad f25ba8b6 635eac5d 8969e5d9
		NSLog(@"pushing......");
        self.deviceToken = @"6240d771 c9a0778e 92aa9a3e 5dd712e2 0ec263ad f25ba8b6 635eac5d 8969e5d9";
		
        self.payload = @"{\"aps\":{\"alert\":\"You got a new alarm message!\",\"badge\":5,\"sound\":\"Blow.aiff\"},\"acme1\":\"bar\",\"acme2\":42}";
		
        self.certificate = [[NSBundle mainBundle] 
							pathForResource:@"aps_development" ofType:@"cer"];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//toggle = YES;
	savedRecordings=[[NSMutableArray alloc]init];
	
	
		//lblStatusMsg.text = @"Stopped";
	//progressView.progress = 0.0;
}
-(void)viewWillAppear:(BOOL)animated
{
	toggle = YES;
	
	lblStatusMsg.text = @"Stopped";
	progressView.progress = 0.0;
	
	 [self InitialCheckMethod];
	
	
}



-(IBAction)btnSetAlarm_Clicked
{
	SetAlarm *alarm=[[SetAlarm alloc]init];
	
	alarm.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:alarm animated:NO];
	
	
	
}

-(IBAction)btnViewAlarm_Clicked
{
	
	ViewAlarm *viewAlarm=[[ViewAlarm alloc]init];
	
	viewAlarm.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:viewAlarm animated:NO];
	
	
	
}

- (void) handleTimer
{
	progressView.progress += .07;
	if(progressView.progress == 1.0)
	{
		[timer invalidate];
		lblStatusMsg.text = @"Stopped";
	}
}


-(IBAction)startRecording

{
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [searchPaths objectAtIndex:0];
	NSLog(@"ccc...%@",documentPath);
	
	
	if(toggle)
	{
		toggle = NO;
		//[btnStart setTitle:@"Stop Recording" forState: UIControlStateNormal ];	
		//btnPlay.enabled = toggle;
		//btnPlay.hidden = !toggle;
		
		//Begin the recording session.
		//Error handling removed.  Please add to your own code.
		
		//Setup the dictionary object with all the recording settings that this 
		//Recording sessoin will use
		//Its not clear to me which of these are required and which are the bare minimum.
		//This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
		//
//		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
//		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
//		[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//		
		
		
		
		recordSetting = [[NSMutableDictionary alloc] init];
		
		// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
		
		// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		
		// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
		[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
		
		
		//Now that we have our settings we are going to instanciate an instance of our recorder instance.
		//Generate a temp file for use by the recording.
		//This sample was one I found online and seems to be a good choice for making a tmp file that
		//will not overwrite an existing one.
		//I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
		strRecordedVoice=[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"];
		//recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
		recordedTmpFile = [NSURL fileURLWithPath:[documentPath stringByAppendingPathComponent:strRecordedVoice]];
		NSLog(@"Using Filepath called: %@",recordedTmpFile);
		
		
		//file://localhost/var/mobile/Applications/CD1FAE28-9678-4BD2-8136-FCB15ED4113A/Documents/366783337550.caf
		//
		NSLog(@"Using str: %@",strRecordedVoice);
		//Setup the recorder to use this file and record to it.
		recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
		
		
		
		
		//Use the recorder to start the recording.
		//Im not sure why we set the delegate to self yet.  
		//Found this in antother example, but Im fuzzy on this still.
		[recorder setDelegate:self];
		//We call this to start the recording process and initialize 
		//the subsstems so that when we actually say "record" it starts right away.
		[recorder prepareToRecord];
		//Start the actual Recording
		[recorder record];
		//There is an optional method for doing the recording for a limited time see 
		//[recorder recordForDuration:(NSTimeInterval) 10]
		progressView.progress = 0.0;
		[recorder recordForDuration:(NSTimeInterval) 2];
		
		lblStatusMsg.text = @"Recording...";
		progressView.progress = 0.0;
		timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
		
		
		
	}
	else
	{
		toggle = YES;
		//[actSpinner stopAnimating];
	//	[btnStart setTitle:@"Start Recording" forState:UIControlStateNormal ];
	//	btnPlay.enabled = toggle;
	//	btnPlay.hidden = !toggle;
	//	
	//	NSLog(@"Using File called: %@",recordedTmpFile);
		//Stop the recorder.
		[recorder stop];
	}
	
	
	
/*	
	recorderFilePath = [[NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER] retain];
	
	NSLog(@"recorderFilePath: %@",recorderFilePath);
	
	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
	
	err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
	if(audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	
	err = nil;
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
	}
	
	//prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
	}
	
	// start recording
	[recorder recordForDuration:(NSTimeInterval) 2];
	
	lblStatusMsg.text = @"Recording...";
	progressView.progress = 0.0;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
	
	*/
	
		
	
	
}
-(IBAction)stopRecording
{


	[recorder stop];
	
	[timer invalidate];
	lblStatusMsg.text = @"Stopped";
	//progressView.progress = 1.0;
	

}



- (IBAction)playSound
{
	avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
	[avPlayer prepareToPlay];
	[avPlayer play];
	
	}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	[timer invalidate];
	lblStatusMsg.text = @"Stopped";
	progressView.progress = 1.0;
}

-(IBAction)saveRecording
{
	iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication] delegate];
	
	
	
//NSString *extension = @"caf";
	//ap.strRecordPath=[NSString stringWithFormat:@"%@",recordedTmpFile];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL]; 
	
	
		NSString *strr=[NSString stringWithFormat:@"%@",[contents objectAtIndex:0]];
	
	//ap.strRecordPath = [NSString stringWithFormat:@"file://localhost/var/mobile/Applications/EF0BF885-B6D5-4786-A225-C64D5922F5F4/Documents/%@", 
	//					   [strr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
		NSLog(@"verifycountcaf...%@",strr);

	ap.audio = [NSData dataWithContentsOfURL:recordedTmpFile];
	
		
		avPlayer = [[AVAudioPlayer alloc] initWithData:ap.audio  error:&error];
		[avPlayer prepareToPlay];
		[avPlayer play];
	
	
	
	
	
	ap.arrRecorded=contents;	
	
	
	
	
	
	
	
	
		
	
	/*
	//NSURL *url = [NSURL URLWithString:@"http://in.orgware.in/Heather/Heather%20voice/phraseaudio1.mp3"];
	NSURLResponse *response;
	NSError *error1;
	NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:recordedTmpFile] returningResponse:&response error:&error1];
	if(data)
	{
		NSArray *pathss = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([pathss count] > 0) ? [pathss objectAtIndex:0] : nil;
		basePath =  [basePath stringByAppendingPathComponent:[recordedTmpFile lastPathComponent]];
		[ap.audio writeToFile:basePath atomically:YES];
		
		
		NSLog(@"basedata...%@",basePath);
		
		ap.strRecordPath =basePath;
	}
	
	*/
	
	
		
	/*
	//NSString *myAudioFileInBundle = @"words.mp3";
    NSTimeInterval wordStartsAt = 1.8;
    NSTimeInterval wordEndsAt = 6.5;
   // NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:myAudioFileInBundle];
//NSURL *myFileURL = [NSURL fileURLWithPath:filePath];
    avPlayer = [[AVAudioPlayer alloc] initWithData:ap.audio  error:&error];

    if (avPlayer) {
        [avPlayer setCurrentTime:wordStartsAt];
        [avPlayer prepareToPlay];
        [avPlayer play];
        [NSTimer 
         scheduledTimerWithTimeInterval:wordEndsAt-wordStartsAt
         target:avPlayer.autorelease
         selector:@selector(stop)
         userInfo:nil
         repeats:NO];
	}
	 */
}
	
	

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    NSFileManager * fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[recordedTmpFile path] error:&error];
	//Call the dealloc on the remaining objects.
	[recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
	
}


- (void)dealloc {
    [super dealloc];
}










-(void)InitialCheckMethod
{
	
	 NSString *UUID=@"44cea3a527d2b375d103c2ae5081948455a5eba5";
   // NSString *post = [NSString stringWithFormat:@"&Unique_Id=%@",UUID];
	NSString *post = [NSString stringWithFormat:@"&Unique_Id=%@",UUID];
    
    NSLog(@"passed data  %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://118.139.178.115/ConnectGolf/DevicesServices/InitialAuthentication.aspx"]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn)
    {
        NSLog(@"Connection Successful");
    }
    else
    {
        NSLog(@"Connection could not be made");
    }
    
    receivedData = [[NSMutableData alloc]init];
    
    
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [receivedData appendData:data];
    
    
}

-(void)handleResponce:(NSString *)data
{
    
    
    SBJsonParser *json = [SBJsonParser new] ;
    NSError *jsonError;
    parsedJSON = [json objectWithString:data error:&jsonError];
    NSLog(@"parsedJSON=====>%@",parsedJSON); 
    
    
    NSLog(@"value of parsed JSON is %d",[parsedJSON count]);
    
    
    bool c = [[parsedJSON objectForKey:@"IsSuccess"] boolValue];
    
	//  NSString *temp=[[parsedJSON objectForKey:@"Role"] stringValue];
    
    NSLog(@"int value %d",c);
    
    
    
        
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    
    NSString* newStr = [[NSString alloc] initWithData:receivedData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"<---------->newStr==%@",newStr);
    
    [self handleResponce:newStr];
    
    
}




- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"Data FInished------->");
    
    
    //  navigationController= [[UINavigationController alloc]initWithRootViewController:test];
    //  navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"" message:@"Error!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertObj show];
    
    
    
    
}




@end
