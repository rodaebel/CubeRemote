//
//  CubeRemoteAppDelegate.h
//  CubeRemote
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "MicLevelController.h"

extern NSString * const kCRAvailableServices;

@class CubeRemoteViewController;

@interface CubeRemoteAppDelegate : NSObject <UIApplicationDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate, AsyncUdpSocketDelegate, UIAccelerometerDelegate, MicLevelControllerDelegate> {
@private
	NSNetServiceBrowser *_serviceBrowser;
	NSMutableArray *_availableServices;

	AsyncUdpSocket *_sendSocket;

	BOOL _isSending;
	BOOL _oscEnabled;
	BOOL _accelerometerEnabled;
}

@property (retain) NSArray *availableServices;
@property (retain) NSString *address;
@property NSInteger port;
@property (assign) BOOL isSending;
@property (assign) BOOL oscEnabled;
@property (assign) BOOL accelerometerEnabled;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CubeRemoteViewController *viewController;
@property (nonatomic, retain) IBOutlet MicLevelController *micLevelController;

- (IBAction)switchOSC:(id)sender;

- (IBAction)switchAccelerometer:(id)sender;

- (IBAction)switchRecorder:(id)sender;

@end
