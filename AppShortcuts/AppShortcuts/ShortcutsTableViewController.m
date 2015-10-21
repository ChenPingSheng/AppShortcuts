//
//  ShortcutsTableViewController.m
//  AppShortcuts
//
//  Created by Kingyee on 15/10/21.
//  Copyright © 2015年 Kingyee. All rights reserved.
//

#import "ShortcutsTableViewController.h"
#import "ShortcutDetailViewController.h"

@interface ShortcutsTableViewController ()

/// Pre-defined shortcuts; retrieved from the Info.plist.
@property (nonatomic, strong) NSArray<UIApplicationShortcutItem *> *staticShortcuts;

/// Shortcuts defined by the application and modifiable based on application state.
@property (nonatomic, strong) NSMutableArray<UIApplicationShortcutItem *> *dynamicShortcuts;

@end

@implementation ShortcutsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *shortcuts = [[NSBundle mainBundle] infoDictionary][@"UIApplicationShortcutItems"];
    NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in shortcuts) {
        NSString *shortcutType = dict[@"UIApplicationShortcutItemType"];
        NSString *shortcutTitle = dict[@"UIApplicationShortcutItemTitle"];
        NSString *localizedTitle = [[NSBundle mainBundle] localizedInfoDictionary][shortcutTitle];
        if (localizedTitle) {
            shortcutTitle = localizedTitle;
        }
        NSString *shortcutSubtitle = dict[@"UIApplicationShortcutItemSubtitle"];
        NSString *localizedSubTitle = [[NSBundle mainBundle] localizedInfoDictionary][shortcutSubtitle];
        if (localizedSubTitle) {
            shortcutSubtitle = localizedSubTitle;
        }
        [shortcutItems addObject:[[UIApplicationShortcutItem alloc] initWithType:shortcutType localizedTitle:shortcutTitle localizedSubtitle:shortcutSubtitle icon:nil userInfo:nil]];
    }
    self.staticShortcuts = shortcutItems;
    
    self.dynamicShortcuts = [NSMutableArray arrayWithArray:[UIApplication sharedApplication].shortcutItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"Static", @"Dynamic"][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.staticShortcuts.count : self.dynamicShortcuts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    // Configure the cell...
    UIApplicationShortcutItem *shortcut = nil;
    
    if (indexPath.section == 0) {
        // Static shortcuts (cannot be edited).
        shortcut = self.staticShortcuts[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        // Dynamic shortcuts.
        shortcut = self.dynamicShortcuts[indexPath.row];
    }
    
    cell.textLabel.text = shortcut.localizedTitle;
    cell.detailTextLabel.text = shortcut.localizedSubtitle;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowShortcutDetail"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        if (indexPath) {
            ShortcutDetailViewController *controller = segue.destinationViewController;
            controller.shortcutItem = self.dynamicShortcuts[indexPath.row];
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath.section > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Actions

// Unwind segue action called when the user taps 'Done' after navigating to the detail controller.
- (IBAction)done:(UIStoryboardSegue *)sender {
    ShortcutDetailViewController *sourceViewController = sender.sourceViewController;
    UIApplicationShortcutItem *updatedShortcutItem = sourceViewController.shortcutItem;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        self.dynamicShortcuts[indexPath.row] = updatedShortcutItem;
        
        [UIApplication sharedApplication].shortcutItems = self.dynamicShortcuts;
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// Unwind segue action called when the user taps 'Cancel' after navigating to the detail controller.
- (IBAction)cancel:(UIStoryboardSegue *)sender {
    
}

@end
