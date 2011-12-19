//
//  MicLevelController.m
//  CubeRemote
//

#import "MicLevelController.h"


@implementation MicLevelController

- (id)initWithDelegate:(id)aDelegate
{
	self = [super init];
	if (self)
	{
		delegate = [aDelegate retain];
	}
	return self;
}

- (void)awakeFromNib
{
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];

	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];

	NSError *error;

	_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];

  	if (_recorder) {
		[_recorder prepareToRecord];
		_recorder.meteringEnabled = YES;
		[_recorder record];
	} else
		NSLog(@"%@", [error description]);
}

- (void)dealloc
{
	[_recorder release];
	_recorder = nil;

	[delegate release];

	[super dealloc];
}

- (void)timerCallback:(NSTimer *)timer
{
	[_recorder updateMeters];

	const double ALPHA = 0.1;
	double peakPowerForChannel = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
	_lowPassResult = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * _lowPassResult;	

	if ([delegate respondsToSelector:@selector(didReceiveMicLevel:)])
		[delegate didReceiveMicLevel:[NSNumber numberWithDouble:_lowPassResult]];
}

- (IBAction)startRecording:(id)sender
{
	if (_recorder) {
		[_recorder prepareToRecord];
		_recorder.meteringEnabled = YES;
		[_recorder record];
		_callbackTimer = [[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES] retain];
	}
}

- (IBAction)stopRecording:(id)sender
{
	[_callbackTimer invalidate];
	[_callbackTimer release];

	if (_recorder.recording)
		[_recorder stop];
}

@end