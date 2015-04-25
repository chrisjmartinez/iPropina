//
//  CategoryPickerViewController.m
//  iPropina
//
//  Created by Chris Martinez on 12/31/12.
//
//

#import "CategoryPickerViewController.h"
#import "RateViewController.h"

@interface CategoryPickerViewController ()
{
    int selectedRow;
}

@end

@implementation CategoryPickerViewController

@synthesize categories = _categories;
@synthesize delegate = _delegate;

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
    self.categories = [[NSArray alloc] initWithObjects:@"",
                       @"African",
                       @"American",
                       @"Argentinean",
                       @"Asian",
                       @"Asian Fusion",
                       @"Bagels",
                       @"Bakery",
                       @"Barbecue",
                       @"Brazilian",
                       @"Breakfast",
                       @"Brewery",
                       @"Cajun and Creole",
                       @"Californian",
                       @"Caribbean",
                       @"Cheese Steaks",
                       @"Chinese",
                       @"Coffeehouse",
                       @"Continental",
                       @"Deli",
                       @"Dessert",
                       @"Dim Sum",
                       @"Donut Shop",
                       @"Ethiopian",
                       @"European",
                       @"Fast Food",
                       @"Fish and Chips",
                       @"Fondue",
                       @"French",
                       @"Gastropub",
                       @"German",
                       @"Greek",
                       @"Hamburgers",
                       @"Hawaiian",
                       @"Health Food",
                       @"Hot Dogs",
                       @"Ice Cream",
                       @"Indian",
                       @"Irish",
                       @"Italian",
                       @"Japanese",
                       @"Jewish/Kosher",
                       @"Korean",
                       @"Mediterranean",
                       @"Mexican",
                       @"Middle Eastern",
                       @"Mongolian",
                       @"Moroccan",
                       @"Noodle Shop",
                       @"Pan-Asian",
                       @"Persian",
                       @"Peruvian",
                       @"Pizza",
                       @"Polynesian",
                       @"Portuguese",
                       @"Pub food",
                       @"Puerto Rican",
                       @"Russian",
                       @"Sandwiches",
                       @"Seafood",
                       @"Smoothies and Juices",
                       @"Soul Food",
                       @"Soups and Salads",
                       @"South American",
                       @"Southeast Asian",
                       @"Southern",
                       @"Southwestern",
                       @"Spanish",
                       @"Steakhouse",
                       @"Sushi",
                       @"Tapas / Small Plates",
                       @"Tearoom",
                       @"Tex-Mex",
                       @"Thai",
                       @"Turkish",
                       @"Vegan",
                       @"Vegetarian",
                       @"Vietnamese",
                       @"Wine Bar", nil];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                             style:UIBarButtonItemStyleDone target:self
                                                                            action:@selector(handleDone:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.categories count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedRow = row;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    label.text = [self.categories objectAtIndex:row];
    label.backgroundColor=[UIColor clearColor];
    
    return label;
}

- (IBAction)handleDone:(id)sender {
    [self.delegate categoryUpdated:[self.categories objectAtIndex:selectedRow]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
