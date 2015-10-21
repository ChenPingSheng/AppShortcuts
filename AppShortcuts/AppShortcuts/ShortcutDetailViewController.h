//
//  ShortcutDetailViewController.h
//  AppShortcuts
//
//  Created by Kingyee on 15/10/21.
//  Copyright © 2015年 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortcutDetailViewController : UITableViewController

/// Used to share information between this controller and its parent.
@property (strong, nonatomic) UIApplicationShortcutItem *shortcutItem;

@end
