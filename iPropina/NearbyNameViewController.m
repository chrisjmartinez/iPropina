//
//  NearbyNameViewController.m
//  iPropina
//
//  Created by Chris Martinez on 12/31/12.
//
//

#import "NearbyNameViewController.h"

@interface NearbyNameViewController ()
{
    int selectedRow;
}

@end

@implementation NearbyNameViewController

@synthesize names = _names;


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
    return [self.names count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedRow = row;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    label.backgroundColor=[UIColor clearColor];

    if ([self.names count])
        label.text = [self.names objectAtIndex:row];
    
    return label;
}

- (IBAction)handleDone:(id)sender {
    if ([self.names count])
        [self.delegate nameUpdated:[self.names objectAtIndex:selectedRow]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
