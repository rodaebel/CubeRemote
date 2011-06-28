//
//  CubeRemoteViewController.h
//  CubeRemote
//
//  Created by Tobias on 6/23/11.
//

#import <UIKit/UIKit.h>

@class CubeRemoteAppDelegate;

@interface CubeRemoteViewController : UIViewController <UITableViewDelegate, UITextFieldDelegate> {

	CubeRemoteAppDelegate *appDelegate;

	NSArray *sectionArray;
}

@end
