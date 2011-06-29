//
//  MicLevelController.m
//  CubeRemote
//
//  Created by Tobias on 6/24/11.
//

#import "MicLevelController.h"


@implementation MicLevelController

- (id)initWithDelegate:(id)del
{
	self = [super init];
	if (self)
	{
		delegate = del;
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

	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];

  	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
	} else
		NSLog(@"%@", [error description]);
}

- (void)dealloc
{
	[recorder release];
	recorder = nil;

	[super dealloc];
}

- (void)timerCallback:(NSTimer *)timer
{
	[recorder updateMeters];

	const double ALPHA = 0.1;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResult = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResult;	

	if ([delegate respondsToSelector:@selector(didReceiveMicLevel:)])
		[delegate didReceiveMicLevel:[NSNumber numberWithDouble:lowPassResult]];
}

- (IBAction)startRecording:(id)sender
{
	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
		callbackTimer = [[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES] retain];
	}
}

- (IBAction)stopRecording:(id)sender
{
	[callbackTimer invalidate];
	[callbackTimer release];

	if (recorder.recording)
		[recorder stop];
}

@end