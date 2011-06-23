//
//  CubeRemoteViewController.m
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import "CubeRemoteViewController.h"
#import "CubeRemoteAppDelegate.h"

@implementation CubeRemoteViewController

@synthesize toggleOnOff = _toggleOnOff;

- (void)dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
	[super viewDidUnload];
	[_toggleOnOff release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier = @"SomeIdentifier";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.text = @"Transmitting OSC";
		UISwitch *toggleOnOff = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		cell.accessoryView = toggleOnOff;
		[(UISwitch *)cell.accessoryView setOn:NO];
		[(UISwitch *)cell.accessoryView addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
	}

	return cell;
}

#pragma mark - API

- (IBAction)switchDidChangeValue:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);

	CubeRemoteAppDelegate * applicationDelegate = (CubeRemoteAppDelegate *)[[UIApplication sharedApplication] delegate];

	UISwitch * mySwitch = (UISwitch *)sender;

	[applicationDelegate switchOnOff:mySwitch.on];
}

@end
