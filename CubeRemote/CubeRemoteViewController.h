//
//  CubeRemoteViewController.h
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import <UIKit/UIKit.h>

@class CubeRemoteAppDelegate;

@interface CubeRemoteViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UISwitch * toggleOnOff;

- (IBAction)switchDidChangeValue:(id)sender;

@end
