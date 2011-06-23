//
//  CubeRemoteViewController.m
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import "CubeRemoteViewController.h"
#import "CubeRemoteAppDelegate.h"

@implementation CubeRemoteViewController

@synthesize toggleOnOff;

- (void)dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - API

- (IBAction)switchDidChangeValue:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);

	CubeRemoteAppDelegate * applicationDelegate = (CubeRemoteAppDelegate *)[[UIApplication sharedApplication] delegate];

	UISwitch * mySwitch = (UISwitch *)sender;

	[applicationDelegate sendOnOff:mySwitch.on];
}

@end
