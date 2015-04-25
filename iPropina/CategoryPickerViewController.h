//
//  CategoryPickerViewController.h
//  iPropina
//
//  Created by Chris Martinez on 12/31/12.
//
//

#import <UIKit/UIKit.h>

@protocol CategoryPickerViewControllerDelegate
-(void)categoryUpdated:(NSString *)categoryString;
@end

@interface CategoryPickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)handleDone:(id)sender;

@property (strong, nonatomic) NSArray * categories;
@property (nonatomic, assign) id <CategoryPickerViewControllerDelegate> delegate;

@end
