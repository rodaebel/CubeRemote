//
//  CubeRemoteAppDelegate.h
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "MicLevelController.h"

@class CubeRemoteViewController;

@interface CubeRemoteAppDelegate : NSObject <UIApplicationDelegate, AsyncUdpSocketDelegate, UIAccelerometerDelegate, MicLevelControllerDelegate> {
@private
	AsyncUdpSocket *sendSocket;

	BOOL oscEnabled;
	BOOL accelerometerEnabled;
}

@property (nonatomic, retain) NSString *address;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CubeRemoteViewController *viewController;

@property (nonatomic, retain) IBOutlet MicLevelController *micLevelController;

- (IBAction)switchOSC:(id)sender;

- (IBAction)switchAccelerometer:(id)sender;

- (IBAction)switchRecorder:(id)sender;

@end
