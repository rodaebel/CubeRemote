//
//  MicLevelController.h
//  CubeRemote
//
//  Created by Tobias on 6/24/11.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol MicLevelControllerDelegate
@optional
- (void)didReceiveMicLevel:(NSNumber *)level;

@end


@interface MicLevelController : NSObject {
@private
	AVAudioRecorder *recorder;
	NSTimer *callbackTimer;
	double lowPassResult;
@public
	IBOutlet NSObject<MicLevelControllerDelegate> *delegate;
}

- (IBAction)startRecording:(id)sender;

- (IBAction)stopRecording:(id)sender;

@end
