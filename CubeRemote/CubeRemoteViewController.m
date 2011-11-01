//
//  CubeRemoteViewController.m
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import "CubeRemoteViewController.h"
#import "CubeRemoteAppDelegate.h"

@implementation CubeRemoteViewController

- (void)awakeFromNib
{
	appDelegate = (CubeRemoteAppDelegate *)[[UIApplication sharedApplication] delegate];;
}

- (void)dealloc
{
	appDelegate = nil;

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
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

	if (cell == nil) {

		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		switch (indexPath.row) {
			case 0:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.text = NSLocalizedString(@"CRAddress", "Enter address");
	
				UITextField *addrField = [[[UITextField alloc] initWithFrame:CGRectMake(150, 12, 150, 30)] autorelease];
				addrField.adjustsFontSizeToFitWidth = YES;
				addrField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
				addrField.autoresizesSubviews = YES;
				addrField.text = appDelegate.address;
				addrField.textAlignment = UITextAlignmentRight;
				addrField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				addrField.delegate = self;

				[cell addSubview:addrField];
				break;
			case 1:
				cell.textLabel.text = NSLocalizedString(@"CRToggleOSC", "Switch on/off OSC");

				UISwitch *toggleOSC = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleOSC setOn:NO];
				[toggleOSC addTarget:appDelegate action:@selector(switchOSC:) forControlEvents:UIControlEventValueChanged];

				cell.accessoryView = toggleOSC;
				break;
			case 2:
				cell.textLabel.text = NSLocalizedString(@"CRToggleAccelerometer", "Switch on/off accelerometer");

				UISwitch *toggleAccelerometer = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleAccelerometer setOn:NO];
				[toggleAccelerometer addTarget:appDelegate action:@selector(switchAccelerometer:) forControlEvents:UIControlEventValueChanged];

				cell.accessoryView = toggleAccelerometer;
				break;
			case 3:
				cell.textLabel.text = NSLocalizedString(@"CRToggleRec", "Switch on/off microphone");

				UISwitch *toggleRec = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleRec setOn:NO];
				[toggleRec addTarget:appDelegate action:@selector(switchRecorder:) forControlEvents:UIControlEventValueChanged];

				cell.accessoryView = toggleRec;
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

@end
