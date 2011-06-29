//
//  CubeRemoteTests.m
//  CubeRemoteTests
//
//  Created by Tobias on 6/23/11.
//

#import "CubeRemoteTests.h"

#import "MicLevelController.h"

@interface MyMicLevelControllerDelegate : NSObject<MicLevelControllerDelegate> {

}

@end


@implementation MyMicLevelControllerDelegate

- (void)didReceiveMicLevel:(NSNumber *)level
{

}

@end


@implementation CubeRemoteTests

- (void)testMicLevelController
{
	MyMicLevelControllerDelegate *myDelegate = [[MyMicLevelControllerDelegate alloc] init];
    MicLevelController* micLevelController = [[MicLevelController alloc] initWithDelegate:myDelegate];

	[micLevelController startRecording:self];
	[micLevelController stopRecording:self];

	[myDelegate release];
	[micLevelController release];
}

@end
