//
//  iPropinaViewController.m
//  iPropina
//
//  Created by Chris Martinez on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "iPropinaViewController.h"
#import "RateViewController.h"

@implementation iPropinaViewController
@synthesize textBillTotal = _textBillTotal;
@synthesize textTipTotal = _textTipToptak;
@synthesize textPerPersonTotal = _textPerPersonTotal;
@synthesize stepDivideBy=_stepDivideBy;
@synthesize stepTipPercent=_stepTipPercent;
@synthesize textDivideBy=_textDivideBy;
@synthesize textTipPercent=_textTipPercent;
@synthesize switchRoundUp=_switchRoundUp;
@synthesize textFinalTotal = _textFinalTotal;
@synthesize fBillTotal=_fBillTotal;
@synthesize nDivideBy=_nDivideBy;
@synthesize fTipTotal=_fTipTotal;
@synthesize fPerPersonTotal=_fPerPersonTotal;
@synthesize bRoundUp=_bRoundUp;
@synthesize fFinalTotal=_fFinalTotal;
@synthesize nTipPct=_nTipPct;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create a view of the standard size at the bottom of the screen.
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                self.view.frame.size.height -
                                                GAD_SIZE_728x90.height,
                                                GAD_SIZE_728x90.width,
                                                GAD_SIZE_728x90.height)];
    } else {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                            self.view.frame.size.height -
                                            self.navigationController.toolbar.frame.size.height -
                                            GAD_SIZE_320x50.height,
                                            GAD_SIZE_320x50.width,
                                            GAD_SIZE_320x50.height)];
    }
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[GADRequest request]];
    
    self.fBillTotal = 0.0;
    self.fFinalTotal = 0.0;
    self.nDivideBy = 1;
    self.fPerPersonTotal = 0.0;
    self.bRoundUp = true;
    self.nTipPct = 15;
    self.fTipTotal = 0.0;
    
    [self updateAllFields];
}

- (void)viewDidUnload
{
    [self setTextBillTotal:nil];
    [self setTextTipTotal:nil];
    [self setTextPerPersonTotal:nil];
    [self setTextFinalTotal:nil];
    [self setTextTipPercent:nil];
    [self setTextDivideBy:nil];
    [self setStepTipPercent:nil];
    [self setStepDivideBy:nil];
    [self setSwitchRoundUp:nil];
    [self setTextBillTotal:nil];
    [self setTextFinalTotal:nil];

    [super viewDidUnload];
// not needed with ARC    [bannerView_ release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (IBAction)updateBillTotal:(id)sender {
    NSString * strBillTotal = self.textBillTotal.text;
    self.fBillTotal = [strBillTotal floatValue];
    [self updateAllFields];
}

- (IBAction)updateTipPercent:(id)sender {
    self.nTipPct = self.stepTipPercent.value;
    self.textTipPercent.text = [NSString stringWithFormat:@"%2d", self.nTipPct];
    [self updateAllFields];
}

- (IBAction)updateDivideBy:(id)sender {
    self.nDivideBy = self.stepDivideBy.value;
    self.textDivideBy.text = [NSString stringWithFormat:@"%2d", self.nDivideBy];
    [self updateAllFields];
    
}

- (IBAction)updateRoundUp:(id)sender {
    if (self.switchRoundUp.on) {
        self.bRoundUp = true;
    } else {
        self.bRoundUp = false;
    }
    
    [self updateAllFields];
}

- (void) updateAllFields {
    
    self.fTipTotal = self.fBillTotal * (self.nTipPct / 100.0);
    
    if (self.bRoundUp) {
        float fRemainder;
        int nTip = self.fTipTotal;
        int nTotal = self.fBillTotal;
        fRemainder = self.fBillTotal - nTotal;
        
        if (fRemainder > 0.0) {
            self.fTipTotal = nTip + 1.0 - fRemainder;
        }
    }
    
    self.fFinalTotal = self.fBillTotal + self.fTipTotal;
    
    if (self.bRoundUp) {
        self.fFinalTotal = ceil(self.fFinalTotal);
    }
    
    self.fPerPersonTotal = self.fFinalTotal / self.nDivideBy;
    self.textFinalTotal.text = [NSString stringWithFormat:@"%6.2f", self.fFinalTotal];
    self.textPerPersonTotal.text = [NSString stringWithFormat:@"%6.2f", self.fPerPersonTotal];
    self.textTipPercent.text = [NSString stringWithFormat:@"%2d", self.nTipPct];
    self.stepTipPercent.value = self.nTipPct;
    self.stepDivideBy.value = self.nDivideBy;
    self.textDivideBy.text = [NSString stringWithFormat:@"%2d", self.nDivideBy];
    self.textTipTotal.text = [NSString stringWithFormat:@"%6.2f", self.fTipTotal];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.textBillTotal resignFirstResponder];
}

@end
