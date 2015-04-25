//
//  RateViewController.h
//  iPropina
//
//  Created by Chris Martinez on 12/24/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CategoryPickerViewController.h"
#import "NearbyNameViewController.h"
#import "RateView.h"

@interface RateViewController : UIViewController <CLLocationManagerDelegate, UITextViewDelegate, UITextFieldDelegate,NearbyNameViewControllerDelegate,CategoryPickerViewControllerDelegate,NSXMLParserDelegate,RateViewDelegate>
- (IBAction)backToParent:(id)sender;
- (IBAction)sendRateInfo:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)searchForNames:(id)sender;

+ (NSString*)encodeURL:(NSString *)string;

@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (strong, nonatomic) IBOutlet UIScrollView *theScroller;
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textCategory;
@property (strong, nonatomic) IBOutlet UITextView *textComments;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerType;
@property (copy, readwrite) CLLocation * location;
@property (strong, nonatomic) CLLocationManager * locMan;

@end
