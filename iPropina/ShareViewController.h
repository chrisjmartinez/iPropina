//
//  ShareViewController.h
//  iPropina
//
//  Created by Chris Martinez on 2/10/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)facebook:(id)sender;
- (IBAction)email:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)instagram:(id)sender;
@end
