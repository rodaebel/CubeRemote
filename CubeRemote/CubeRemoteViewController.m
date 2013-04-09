//
//  CubeRemoteViewController.m
//  CubeRemote
//

#import "CubeRemoteViewController.h"
#import "CubeRemoteAppDelegate.h"

#include <arpa/inet.h>

@implementation CubeRemoteViewController

@synthesize tableView = _tableView;

- (void)awakeFromNib
{
	_appDelegate = [(CubeRemoteAppDelegate *)[[UIApplication sharedApplication] delegate] retain];
}

- (void)dealloc
{
	[_appDelegate release];

	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

#pragma mark - Key-Value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:kCRAvailableServices]) [self updateUserInterface];
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

#pragma mark - Public accessors

- (void)updateUserInterface
{
	[_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - UITableView data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return ((BOOL)[_appDelegate.availableServices count]) ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *retval = @"";

	switch (section)
	{
		case 0:
			retval = NSLocalizedString(@"CROpenSoundControl", "OSC Label");
			break;

		case 1:
			retval = NSLocalizedString(@"CRAvailableServers", "Available Servers Label");
			break;
	}

	return retval;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger retval = 0;

	switch (section)
	{
		case 0:
			retval = 5;
			break;
		case 1:
			retval = [_appDelegate.availableServices count];
			break;
	}

	return retval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"Cell";

	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];

	if (indexPath.section == 0)
	{
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		switch (indexPath.row)
		{
			case 0:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.text = NSLocalizedString(@"CRAddress", "Enter address");
				UITextField *addrField = [[[UITextField alloc] initWithFrame:CGRectMake(150, 12, 150, 30)] autorelease];
				addrField.adjustsFontSizeToFitWidth = YES;
				addrField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
				addrField.autoresizesSubviews = YES;
				addrField.text = _appDelegate.address;
				addrField.textAlignment = NSTextAlignmentRight;
				addrField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				addrField.delegate = self;
				[cell addSubview:addrField];
				_addressField = addrField;
				break;
			case 1:
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.textLabel.text = NSLocalizedString(@"CRPort", "Enter port");
				UITextField *portField = [[[UITextField alloc] initWithFrame:CGRectMake(150, 12, 150, 30)] autorelease];
				portField.adjustsFontSizeToFitWidth = YES;
				portField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
				portField.autoresizesSubviews = YES;
				portField.text = [NSString stringWithFormat:@"%i", _appDelegate.port];
				portField.textAlignment = NSTextAlignmentRight;
				portField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				portField.delegate = self;
				[cell addSubview:portField];
				_portField = portField;
				break;
			case 2:
				cell.textLabel.text = NSLocalizedString(@"CRToggleOSC", "Switch on/off OSC");
				UISwitch *toggleOSC = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleOSC setOn:_appDelegate.oscEnabled];
				[toggleOSC addTarget:_appDelegate action:@selector(switchOSC:) forControlEvents:UIControlEventValueChanged];
				cell.accessoryView = toggleOSC;
				break;
			case 3:
				cell.textLabel.text = NSLocalizedString(@"CRToggleAccelerometer", "Switch on/off accelerometer");
				UISwitch *toggleAccelerometer = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleAccelerometer setOn:_appDelegate.accelerometerEnabled];
				[toggleAccelerometer addTarget:_appDelegate action:@selector(switchAccelerometer:) forControlEvents:UIControlEventValueChanged];
				cell.accessoryView = toggleAccelerometer;
				break;
			case 4:
				cell.textLabel.text = NSLocalizedString(@"CRToggleRec", "Switch on/off microphone");
				UISwitch *toggleRec = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
				[toggleRec setOn:_appDelegate.isSending];
				[toggleRec addTarget:_appDelegate action:@selector(switchRecorder:) forControlEvents:UIControlEventValueChanged];
				cell.accessoryView = toggleRec;
				break;
			default:
				break;
		}
	}

	switch (indexPath.section)
	{
		case 0:
			if (indexPath.row == 0) _addressField.text = _appDelegate.address;
			else if (indexPath.row == 1) _portField.text = [NSString stringWithFormat:@"%i", _appDelegate.port];
			break;
		case 1:
			@try
			{
				cell.textLabel.text = [(NSNetService *)[_appDelegate.availableServices objectAtIndex:indexPath.row] name];
			}
			@catch (id theException)
			{
				cell.textLabel.text = @"Unknown";
			}
			break;
	}

	return cell;
}

#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1)
	{
		NSNetService *service = (NSNetService *)[_appDelegate.availableServices objectAtIndex:indexPath.row];
		[_appDelegate setAddress:[NSString stringWithFormat:@"%@", [service hostName]]];
		[_appDelegate setPort:[service port]];
		[_tableView deselectRowAtIndexPath:indexPath animated:NO];
		[_tableView reloadData];
	}
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ([textField isEqual:_addressField]) _appDelegate.address = textField.text;
	else if ([textField isEqual:_portField]) _appDelegate.port = [textField.text integerValue];
}

@end
