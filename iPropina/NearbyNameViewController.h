//
//  NearbyNameViewController.h
//  iPropina
//
//  Created by Chris Martinez on 12/31/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol NearbyNameViewControllerDelegate
-(void)nameUpdated:(NSString *)nameString;
@end

@interface NearbyNameViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)handleDone:(id)sender;

@property (strong, nonatomic) NSArray * names;
@property (nonatomic, assign) id <NearbyNameViewControllerDelegate> delegate;
@end
