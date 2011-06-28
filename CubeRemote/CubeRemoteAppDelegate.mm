//
//  CubeRemoteAppDelegate.m
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import "CubeRemoteAppDelegate.h"
#import "CubeRemoteViewController.h"

#import "osc/OscOutboundPacketStream.h"


#define BUFFER_SIZE 1024

#define DEFAULT_ADDRESS @"10.0.1.31"

#define PORT 7000

#define kUpdateFrequency 60.0

#define kOSCAccelerationPath "/accxyz"

#define kOSCTogglePath "/1/toggle1"

#define kOSCFaderPath "/1/fader1"


@implementation CubeRemoteAppDelegate

@synthesize address = _address;

@synthesize window = _window;

@synthesize viewController = _viewController;

@synthesize micLevelController = _micLevelController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	oscEnabled = NO;
	accelerometerEnabled = NO;

	self.address = DEFAULT_ADDRESS;
	
	// Setup asynchronous UDP socket
	self->sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
	[sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	
	// Setup acceletometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	 
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)dealloc
{
	if (self->sendSocket) {
		[sendSocket closeAfterSending];
		[sendSocket release];
		sendSocket = nil;
	}

	[_address release];

	[_window release];
	[_viewController release];
	[super dealloc];
}

#pragma - mark UIAccelerometerDelegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (oscEnabled && accelerometerEnabled) {
		// Send accelerometer data
		char buffer[BUFFER_SIZE];

		osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
		packet << osc::BeginMessage(kOSCAccelerationPath) << (float)acceleration.x << (float)acceleration.y << (float)acceleration.z << osc::EndMessage;

		[sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:self.address port:PORT withTimeout:-1 tag:0];
	}
}

#pragma mark - MicLevelControllerDelegate methods

- (void)didReceiveMicLevel:(NSNumber *)level
{
	if (oscEnabled) {
		// Send microphone level data
		char buffer[BUFFER_SIZE];

		osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
		packet << osc::BeginMessage(kOSCFaderPath) << (float)[level floatValue] << osc::EndMessage;

		[sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:self.address port:PORT withTimeout:-1 tag:0];
	}
}

#pragma mark - API

- (IBAction)switchOSC:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch *mySwitch = (UISwitch *)sender;
	oscEnabled = mySwitch.on;
	
	char buffer[BUFFER_SIZE];
	
	osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
	packet << osc::BeginMessage(kOSCTogglePath) << (float)oscEnabled << osc::EndMessage;
	
	[sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:self.address port:PORT withTimeout:-1 tag:0];
}

- (IBAction)switchAccelerometer:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch *mySwitch = (UISwitch *)sender;
	accelerometerEnabled = mySwitch.on;
}

- (IBAction)switchRecorder:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch *mySwitch = (UISwitch *)sender;

	if (mySwitch.on)
		[self.micLevelController startRecording:self];
	else
		[self.micLevelController stopRecording:self];
	
}

@end
