//
//  CubeRemoteAppDelegate.mm
//  CubeRemote
//

#import "CubeRemoteAppDelegate.h"
#import "CubeRemoteViewController.h"

#import "osc/OscOutboundPacketStream.h"

#define BUFFER_SIZE 1024

#define DEFAULT_ADDRESS @"10.0.1.31"

#define DEFAULT_PORT 6123

const float kUpdateFrequency = 60.0;

const char * const kOSCAccelerationPath = "/accxyz";

const char * const kOSCTogglePath = "/1/toggle1";

const char * const kOSCFaderPath = "/1/fader1";

NSString * const kCRAvailableServices = @"availableServices";


@implementation CubeRemoteAppDelegate

@dynamic availableServices;

@synthesize address = _address;
@synthesize port = _port;
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize micLevelController = _micLevelController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Setup domain browser
	_availableServices = [[NSMutableArray alloc] init];
	_serviceBrowser = [[NSNetServiceBrowser alloc] init];
	[_serviceBrowser setDelegate:self];
	[_serviceBrowser searchForServicesOfType:@"_osc._udp" inDomain:@""];

	_oscEnabled = NO;
	_accelerometerEnabled = NO;

	_address = DEFAULT_ADDRESS;
	_port = DEFAULT_PORT;

	// Setup asynchronous UDP socket
	_sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
	[_sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

	// Setup acceletometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];

	self.window.rootViewController = _viewController;
	[self.window makeKeyAndVisible];

	[self addObserver:_viewController forKeyPath:kCRAvailableServices options:NSKeyValueChangeInsertion context:nil];

	return YES;
}

- (void)dealloc
{
	[self removeObserver:_viewController forKeyPath:kCRAvailableServices];

	if (_sendSocket) {
		[_sendSocket closeAfterSending];
		[_sendSocket release];
		_sendSocket = nil;
	}

	[_address release];

	[_window release];
	[_viewController release];

	[_serviceBrowser release];
	[_availableServices release];

	[super dealloc];
}

- (NSArray *)availableServices
{
	NSArray *retval;
	@synchronized(_availableServices)
	{
		retval = [_availableServices copy];
	}
	return [retval autorelease];
}

#pragma mark - NSNetServiceBrowserDelegate methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	[aNetService retain];
	[aNetService setDelegate:self];
	[aNetService resolveWithTimeout:10];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
	[self willChangeValueForKey:kCRAvailableServices];
	[_availableServices removeObject:aNetService];
	[self didChangeValueForKey:kCRAvailableServices];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	[self willChangeValueForKey:kCRAvailableServices];
	[_availableServices addObject:sender];
	[self didChangeValueForKey:kCRAvailableServices];
	[sender release];
}

#pragma mark - UIAccelerometerDelegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (_oscEnabled && _accelerometerEnabled) {
		// Send accelerometer data
		char buffer[BUFFER_SIZE];

		osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
		packet << osc::BeginMessage(kOSCAccelerationPath) << (float)acceleration.x << (float)acceleration.y << (float)acceleration.z << osc::EndMessage;

		[_sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:_address port:_port withTimeout:-1 tag:0];
	}
}

#pragma mark - MicLevelControllerDelegate methods

- (void)didReceiveMicLevel:(NSNumber *)level
{
	if (_oscEnabled) {
		// Send microphone level data
		char buffer[BUFFER_SIZE];

		osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
		packet << osc::BeginMessage(kOSCFaderPath) << (float)[level floatValue] << osc::EndMessage;

		[_sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:_address port:_port withTimeout:-1 tag:0];
	}
}

#pragma mark - API

- (IBAction)switchOSC:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch *mySwitch = (UISwitch *)sender;
	_oscEnabled = mySwitch.on;
	
	char buffer[BUFFER_SIZE];
	
	osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
	packet << osc::BeginMessage(kOSCTogglePath) << (float)_oscEnabled << osc::EndMessage;
	
	[_sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:_address port:_port withTimeout:-1 tag:0];
}

- (IBAction)switchAccelerometer:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch *mySwitch = (UISwitch *)sender;
	_accelerometerEnabled = mySwitch.on;
}

- (IBAction)switchRecorder:(id)sender
{
	assert([sender isKindOfClass:[UISwitch class]]);
	UISwitch *mySwitch = (UISwitch *)sender;

	if (mySwitch.on)
		[_micLevelController startRecording:self];
	else
		[_micLevelController stopRecording:self];
	
}

@end