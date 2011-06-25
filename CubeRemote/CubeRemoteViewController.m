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

- (void)awakeFromNib
{
	appDelegate = (CubeRemoteAppDelegate *)[[UIApplication sharedApplication] delegate];;
}

- (void)dealloc
{
	appDelegate = nil;
	[_toggleOnOff release];

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
	NSLog(@"View did unload");
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *sectionHeader = nil;

	if (section == 0)
		sectionHeader = NSLocalizedString(@"CROpenSoundControl", "OSC Label");;

	return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

	if (cell == nil) {

		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = NSLocalizedString(@"CRToggleOSC", "Toggle transmitting OSC data");

				UISwitch *toggleOnOff = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleOnOff setOn:NO];
				[toggleOnOff addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];

				cell.accessoryView = toggleOnOff;
				break;
			case 1:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.text = NSLocalizedString(@"CRAddress", "Enter address");

				UITextField *addrField = [[[UITextField alloc] initWithFrame:CGRectMake(215, 12, 100, 30)] autorelease];
				addrField.adjustsFontSizeToFitWidth = YES;
				addrField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
				addrField.autoresizesSubviews = YES;
				addrField.text = appDelegate.address;
				addrField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				addrField.delegate = self;

				[cell addSubview:addrField];
				break;
			default:
				break;
		}
	}

	return cell;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	appDelegate.address = textField.text;	
}

#pragma mark - API

- (IBAction)switchDidChangeValue:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch * mySwitch = (UISwitch *)sender;
	[appDelegate switchOnOff:mySwitch.on];
}

@end
