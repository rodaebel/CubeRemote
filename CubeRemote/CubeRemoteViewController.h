//
//  CubeRemoteViewController.h
//  CubeRemote
//

#import <UIKit/UIKit.h>

@class CubeRemoteAppDelegate;

@interface CubeRemoteViewController : UIViewController <UITableViewDelegate, UITextFieldDelegate>
{
@private
	CubeRemoteAppDelegate *_appDelegate;
	UITextField *_addressField;
	UITextField *_portField;
}

@property (assign) IBOutlet UITableView *tableView;

- (void)updateUserInterface;

@end
