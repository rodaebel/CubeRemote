//
//  CubeRemoteAppDelegate.m
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import "CubeRemoteAppDelegate.h"
#import "CubeRemoteViewController.h"

#import "osc/OscOutboundPacketStream.h"


#define BUFFER_SIZE						1024

#define kOutgoingAddress			@"10.0.1.31" // TODO Should be configurrable

#define kOutgoingPort					7000

#define kUpdateFrequency			60.0

#define kOSCAccelerationPath	"/accxyz"

#define kOSCTogglePath				"/1/toggle1"

#define kOSCFaderPath					"/1/fader1"


@implementation CubeRemoteAppDelegate


@synthesize window = _window;

@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	enabled = NO;
	
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

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	if (self->sendSocket) {
		[sendSocket closeAfterSending];
		[sendSocket release];
		sendSocket = nil;
	}

	[_window release];
	[_viewController release];
	[super dealloc];
}

#pragma - mark UIAccelerometerDelegate methods

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (enabled) {
		// Send accelerometer data
		char buffer[BUFFER_SIZE];

		osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);

		packet << osc::BeginMessage(kOSCAccelerationPath) << (float)acceleration.x << (float)acceleration.y << (float)acceleration.z << osc::EndMessage;

		[sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:kOutgoingAddress port:kOutgoingPort withTimeout:-1 tag:0];
	}
}

#pragma mark - API

- (void)sendOnOff:(BOOL)value
{
	enabled = value;

	char buffer[BUFFER_SIZE];
	
	osc::OutboundPacketStream packet(buffer, BUFFER_SIZE);
	
	packet << osc::BeginMessage(kOSCTogglePath) << (float)value << osc::EndMessage;
	
	[sendSocket sendData:[NSData dataWithBytes:packet.Data() length:packet.Size()] toHost:kOutgoingAddress port:kOutgoingPort withTimeout:-1 tag:0];
}

@end
