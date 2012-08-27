//
//  ViewAlarm.m
//  iTalkAlarm
//
//  Created by ugsw on 30/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewAlarm.h"


@implementation ViewAlarm
@synthesize tableViewAlarm;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



-(IBAction)btnRecord_Clicked
{
	RecordVoice *record=[[RecordVoice alloc]init];
	
	record.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:record animated:NO];
	
	
	
}

-(IBAction)btnSetAlarm_Clicked
{
	
	SetAlarm *setAlarm=[[SetAlarm alloc]init];
	
	setAlarm.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:setAlarm animated:NO];
	
	
	
}

-(IBAction)btnBack_click
{

[self dismissModalViewControllerAnimated:YES];


}
-(IBAction)Edit_Click
{


	[self btnSetAlarm_Clicked];



}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication] delegate];
	
	 return [ap.arrAlarmTime count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
	
	iTalkAlarmAppDelegate *ap=[[UIApplication sharedApplication] delegate];
    
    CustomViewAlarmTable *cell = (CustomViewAlarmTable *)[tableViewAlarm dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[CustomViewAlarmTable alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];    
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.lblAlarmName.lineBreakMode = UILineBreakModeWordWrap;
    cell.lblAlarmName.numberOfLines = 0;
    cell.lblAlarmName.font = [UIFont systemFontOfSize:20];
    
    cell.lblAlarmTime.lineBreakMode = UILineBreakModeWordWrap;
    cell.lblAlarmTime.numberOfLines = 0;
    cell.lblAlarmTime.font = [UIFont systemFontOfSize:20];
    
	
	
	
	
	//NSLog(@"array check viewName..%@",[ap.arrAlarmName objectAtIndex:indexPath.row]);
	//NSLog(@"array check viewTime..%@",ap.arrAlarmTime);
	
        
    cell.lblAlarmName.text =[ap.arrAlarmName objectAtIndex:indexPath.row];
    cell.lblAlarmTime.text =[ap.arrAlarmTime objectAtIndex:indexPath.row];
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
	
	    
    
    
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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
