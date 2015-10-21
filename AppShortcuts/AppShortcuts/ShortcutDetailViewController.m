//
//  ShortcutDetailViewController.m
//  AppShortcuts
//
//  Created by Kingyee on 15/10/21.
//  Copyright © 2015年 Kingyee. All rights reserved.
//

#import "ShortcutDetailViewController.h"
#import "AppDelegate.h"

@interface ShortcutDetailViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subtitleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) NSArray<NSString *> *pickerItems;

/// The observer token for the `UITextFieldDidChangeNotification`.
@property (strong, nonatomic) id textFieldObserverToken;

@end

@implementation ShortcutDetailViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.textFieldObserverToken];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerItems = @[@"Compose", @"Play", @"Pause", @"Add", @"Location", @"Search", @"Share"];
    
    if (self.shortcutItem) {
        self.title = self.shortcutItem.localizedTitle;
        self.titleTextField.text = self.shortcutItem.localizedTitle;
        self.subtitleTextField.text = self.shortcutItem.localizedSubtitle;
        
        id value = self.shortcutItem.userInfo[applicationShortcutUserInfoIconKey];
        NSInteger iconValue = [value integerValue];
        UIApplicationShortcutIconType iconType = [self iconTypeForSelectedRow:iconValue];
        
        [self.pickerView selectRow:iconType inComponent:0 animated:NO];
        
        self.textFieldObserverToken = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.doneButton.enabled = self.titleTextField.text.length > 0;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIApplicationShortcutIconType)iconTypeForSelectedRow:(NSInteger)row {
    if (row <= UIApplicationShortcutIconTypeShare) {
        return row;
    }
    else {
        return UIApplicationShortcutIconTypeCompose;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerItems.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerItems[row];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShortcutDetailUpdated"]) {
        UIApplicationShortcutIconType iconType = [self iconTypeForSelectedRow:[self.pickerView selectedRowInComponent:0]];
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:iconType];
        
        self.shortcutItem = [[UIApplicationShortcutItem alloc] initWithType:self.shortcutItem.type localizedTitle:self.titleTextField.text localizedSubtitle:self.subtitleTextField.text icon:icon userInfo:@{applicationShortcutUserInfoIconKey:@([self.pickerView selectedRowInComponent:0])}];
    }
}

@end
