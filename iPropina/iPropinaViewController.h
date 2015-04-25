//
//  iPropinaViewController.h
//  iPropina
//
//  Created by Chris Martinez on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Import GADBannerView’s definition from the SDK
#import "GADBannerView.h"
#import "CopyTextField.h"

static NSString * const MY_BANNER_UNIT_ID = @"a14ef0d63cad1f2";

@interface iPropinaViewController : UIViewController<UITextFieldDelegate> {   
    // Declare one as an instance variable
    GADBannerView *bannerView_;
}
@property (strong, nonatomic) IBOutlet UITextField *textBillTotal;
@property (strong, nonatomic) IBOutlet CopyTextField *textTipTotal;
@property (strong, nonatomic) IBOutlet CopyTextField *textPerPersonTotal;
@property (strong, nonatomic) IBOutlet UIStepper *stepDivideBy;
@property (strong, nonatomic) IBOutlet UIStepper *stepTipPercent;
@property (strong, nonatomic) IBOutlet CopyTextField *textDivideBy;
@property (strong, nonatomic) IBOutlet CopyTextField *textTipPercent;
@property (strong, nonatomic) IBOutlet UISwitch *switchRoundUp;
@property (strong, nonatomic) IBOutlet CopyTextField *textFinalTotal;

@property (assign, nonatomic) float fBillTotal;
@property (assign, nonatomic) int nDivideBy;
@property (assign, nonatomic) float fPerPersonTotal;
@property (assign, nonatomic) float fTipTotal;
@property (assign, nonatomic) Boolean bRoundUp;
@property (assign, nonatomic) float fFinalTotal;
@property (assign, nonatomic) int nTipPct;

- (IBAction)updateBillTotal:(id)sender;
- (IBAction)updateTipPercent:(id)sender;
- (IBAction)updateDivideBy:(id)sender;
- (IBAction)updateRoundUp:(id)sender;


- (void) updateAllFields;
- (IBAction)hideKeyboard:(id)sender;

@end
