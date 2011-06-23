//
//  CubeRemoteAppDelegate.h
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"

@class CubeRemoteViewController;

@interface CubeRemoteAppDelegate : NSObject <UIApplicationDelegate, AsyncUdpSocketDelegate, UIAccelerometerDelegate> {
@private
	AsyncUdpSocket *sendSocket;

	BOOL enabled;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CubeRemoteViewController *viewController;

- (void)switchOnOff:(BOOL)value;

@end
