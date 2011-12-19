//
//  MicLevelController.h
//  CubeRemote
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol MicLevelControllerDelegate
@optional
- (void)didReceiveMicLevel:(NSNumber *)level;

@end


@interface MicLevelController : NSObject {
@private
	AVAudioRecorder *_recorder;
	NSTimer *_callbackTimer;
	double _lowPassResult;
@public
	IBOutlet NSObject<MicLevelControllerDelegate> *delegate;
}

- (id)initWithDelegate:(id)delegate;

- (IBAction)startRecording:(id)sender;

- (IBAction)stopRecording:(id)sender;

@end
