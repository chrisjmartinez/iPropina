//
//  ShareViewController.m
//  iPropina
//
//  Created by Chris Martinez on 2/10/13.
//
//

#import <Social/SLComposeViewController.h>
#import <Social/SLRequest.h>
#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebook:(id)sender {
    __weak SLComposeViewController * socialComposer;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [socialComposer setInitialText:@""];
        [socialComposer setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [socialComposer dismissViewControllerAnimated:YES completion:nil];
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];

        [self presentViewController:socialComposer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Share via Facebook"
                                                        message:@"You must have a Facebook account on this device to share via Facebook."
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)email:(id)sender {
    MFMailComposeViewController * mailComposer;
    NSArray * emailAddresses = nil;
    
    if ([MFMailComposeViewController canSendMail]) {
        mailComposer = [[MFMailComposeViewController alloc] init];
    
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:emailAddresses];
        [self presentViewController:mailComposer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Send Mail"
                                                        message:@"You must have at least one active email account on this device to send email."
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)twitter:(id)sender {
    __weak SLComposeViewController * socialComposer;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        socialComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [socialComposer setInitialText:@""];
        [socialComposer setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    [socialComposer dismissViewControllerAnimated:YES completion:nil];
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:socialComposer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Share via Twitter"
                                                        message:@"You must have a Twitter account on this device to share via Twitter."
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)instagram:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Share via Instagram"
                                                        message:@"You must have an Instagram account on this device to share via Instagram."
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
