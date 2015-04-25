//
//  RateViewController.m
//  iPropina
//
//  Created by Chris Martinez on 12/24/12.
//
//

#import "RateViewController.h"
#import "CategoryPickerViewController.h"
#import "NearbyNameViewController.h"
#import "ShareViewController.h"

@interface RateViewController ()
{
    UITextField * activeField;
    UITextView * activeView;
    CategoryPickerViewController * categoryPicker;
    NearbyNameViewController * nearbyNamePicker;
    NSMutableData * receivedData;
    NSMutableString * currentElementValue;
    NSMutableArray * names;
    BOOL submission;
}
@end

@implementation RateViewController

@synthesize textName = _textName;
@synthesize textCategory = _textCategory;
@synthesize textComments = _textComments;
@synthesize pickerType = _pickerType;
@synthesize location = _location;
@synthesize locMan = _locMan;
@synthesize rateView = _rateView;
@synthesize theScroller = _theScroller;

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
    self.location = [CLLocation alloc];
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    self.locMan.desiredAccuracy = kCLLocationAccuracyBest;// kCLLocationAccuracyBestForNavigation;
    self.locMan.distanceFilter = 100;  // 1 mile = 1609
    
    self.theScroller.contentSize = CGSizeMake(340, 400);
    [self registerForKeyboardNotifications];
    [self.locMan startUpdatingLocation];

    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(sendRateInfo:)];
    
    // rate view
    self.rateView.notSelectedImage = [UIImage imageNamed:@"rate_star_empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"rate_star_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"rate_star_full.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    submission = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"shareSeque"])
        if (NSClassFromString(@"UIActivityViewController"))
            return NO;
    
    return YES;
}

- (BOOL) validateFormValues {
    NSString * name = self.textName.text;
    NSString * category = self.textCategory.text;
    NSString * comments = self.textComments.text;

    if ([name length] < 1 ||
        [category length] < 1 ||
        [comments length] < 1) {
        // release the connection, and the data object
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Propina"
                                                    message:@"Please fill in all form values"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
        [alert show];
        return NO;
    }
    
    return YES;
}

- (IBAction)sendRateInfo:(id)sender {
    NSString * name = self.textName.text;
    NSString * category = self.textCategory.text;
    NSString * comments = self.textComments.text;
    double rate = self.rateView.rating;
    double latitude = self.location.coordinate.latitude;
    double longitude = self.location.coordinate.longitude;
    
    if (![self validateFormValues]) {
        return;
    }
    
    submission = YES;
    
    NSString *postString = [[NSString alloc] initWithFormat:@"http://www.stokedsoft.com/propina/rservice.asmx/RateEx?dRate=%f&dLatitude=%f&dLongitude=%f&sName=%@&sCategory=%@&sComments=%@&sDeviceType=%@",
                            rate,
                            latitude,
                            longitude,
                            [RateViewController encodeURL:name],
                            [RateViewController encodeURL:category],
                            [RateViewController encodeURL:comments],
                            [RateViewController encodeURL:[UIDevice currentDevice].model]];

    // upload values
    // TODO - Use HTTPS
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:postString]];
    
    NSURLConnection *theConnection= [[NSURLConnection alloc]
                                     initWithRequest:request delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
    }
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.textName resignFirstResponder];
    [self.textCategory resignFirstResponder];
    [self.textComments resignFirstResponder];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        // turn off the location manager updates
        [self.locMan stopUpdatingLocation];
        [self setLocMan:nil];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.location = newLocation;
    [self.locMan stopUpdatingLocation];
    [self setLocMan:nil];
    
    [self findNearbyRestaurants];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
#if DEBUG
    NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
#endif
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (submission) {
        // release the connection, and the data object
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Propina"
            message:@"Thank you for your rating."
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
    
        [alert show];
    
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // load and parse the XML
        [self loadPlacesFromXML:receivedData];
    }
}

- (IBAction)share:(id)sender {
    
    if(NSClassFromString(@"UIActivityViewController")) {
        // Use the iOS 6 features
        NSString * shareText = [NSString stringWithFormat:@"%@ (%@): %@", self.textName.text, self.textCategory.text, self.textComments.text];
        NSArray *activityItems = [NSArray arrayWithObject:shareText];
    
        /*
         if (_postImage.image != nil) {
            activityItems = @[_postText.text, _postImage.image];
         } else {
            activityItems = @[_postText.text];
         }
         */
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
    }
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.theScroller.contentInset = contentInsets;
    self.theScroller.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (activeField != nil) {
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
            [self.theScroller setContentOffset:scrollPoint animated:YES];
        }
    } else if (activeView != nil) {
        if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeView.frame.origin.y-kbSize.height);
            [self.theScroller setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.theScroller.contentInset = contentInsets;
    self.theScroller.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    activeView = nil;
}

-(void)nameUpdated:(NSString *)nameString {
    self.textName.text = nameString;
}

-(void)categoryUpdated:(NSString *)categoryString {
    self.textCategory.text = categoryString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"nearbySegue"])
    {
        NearbyNameViewController * viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.names = names;
    } else  if ([segue.identifier isEqualToString:@"categorySegue"])
    {
        CategoryPickerViewController * viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
}

-(void) findNearbyRestaurants {
    
    // get location
    float dLatitude = self.location.coordinate.latitude;
    float dLongitude = self.location.coordinate.longitude;
    int nRadius = 1000;
    
    names = [[NSMutableArray alloc] initWithObjects:nil];
    
    // call Places API
    // ex: https://maps.googleapis.com/maps/api/place/search/xml?location=26.581878,-80.140895&radius=500&types=restaurant|food&sensor=true&key=AIzaSyAyBvY2cMwRWoTmvz0ik35R8sYHF4hx8sE
    NSString * postString = [[NSString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&radius=%d&types=%@&sensor=true&key=AIzaSyAyBvY2cMwRWoTmvz0ik35R8sYHF4hx8sE",
                             dLatitude,
                             dLongitude,
                             nRadius,
                             [RateViewController encodeURL:@"restaurant|food"]];
    
    // Call the Google Places API
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:postString]];
    
    NSURLConnection *theConnection= [[NSURLConnection alloc]
                                     initWithRequest:request delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [[NSMutableData data] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}

- (void) loadPlacesFromXML:(NSData *)xml {
    // load and parse the XML objects
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xml];
    
    //Set delegate
    [xmlParser setDelegate:self];
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    if(success)
        NSLog(@"No Errors");
    else
        NSLog(@"Error Error Error!!!");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    NSLog(@"Processing Value: %@", currentElementValue);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"name"]) {
        [names insertObject:currentElementValue atIndex:0];
    }
    
    currentElementValue = nil;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder]; } return YES;
}

#pragma mark - RateViewDelegate
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
#if DEBUG
    NSLog(@"%@", [NSString stringWithFormat:@"rating: %f", rating]);
#endif
}
@end
