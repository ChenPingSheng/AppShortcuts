//
//  AppDelegate.m
//  AppShortcuts
//
//  Created by Kingyee on 15/10/21.
//  Copyright © 2015年 Kingyee. All rights reserved.
//

#import "AppDelegate.h"

NSString *const applicationShortcutUserInfoIconKey = @"applicationShortcutUserInfoIconKey";

@interface AppDelegate ()

/// Saved shortcut item used as a result of an app launch, used later when app is activated.
@property (nonatomic, strong) UIApplicationShortcutItem *launchedShortcutItem;

@property (nonatomic, strong) NSArray *shortcutIdentifiers;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.shortcutIdentifiers = @[@"First",@"Second",@"Third",@"Fourth"];
    
    BOOL shouldPerformAdditionalDelegateHandling = YES;
    
    // If a shortcut was launched, display its information and take the appropriate action
    UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
    if (shortcutItem) {
        self.launchedShortcutItem = shortcutItem;
        // This will block "performActionForShortcutItem:completionHandler" from being called.
        shouldPerformAdditionalDelegateHandling = NO;
    }
    
    // Install initial versions of our two extra dynamic shortcuts.
    if (application.shortcutItems.count == 0) {
        UIMutableApplicationShortcutItem *shortcut3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"Third" localizedTitle:@"Play" localizedSubtitle:@"Will Play an item" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay] userInfo:@{applicationShortcutUserInfoIconKey:@(UIApplicationShortcutIconTypePlay)}];
        UIMutableApplicationShortcutItem *shortcut4 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"Fourth" localizedTitle:@"Pause" localizedSubtitle:@"Will Pause an item" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePause] userInfo:@{applicationShortcutUserInfoIconKey:@(UIApplicationShortcutIconTypePause)}];
        
        application.shortcutItems = @[shortcut3, shortcut4];
    }
    
//    return YES;
    return shouldPerformAdditionalDelegateHandling;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (self.launchedShortcutItem) {
        [self handleShortcutItem:self.launchedShortcutItem];
        self.launchedShortcutItem = nil;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - handle shortcut

/*
 Called when the user activates your application by selecting a shortcut on the home screen, except when
 application(_:,willFinishLaunchingWithOptions:) or application(_:didFinishLaunchingWithOptions) returns `false`.
 You should handle the shortcut in those callbacks and return `false` if possible. In that case, this
 callback is used if your application is already launched in the background.
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    BOOL handledShortCutItem = [self handleShortcutItem:shortcutItem];
    completionHandler(handledShortCutItem);
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    NSString *shortcutType = [[shortcutItem.type componentsSeparatedByString:@"."] lastObject];
    if (![self.shortcutIdentifiers containsObject:shortcutType]) {
        return NO;
    }
    BOOL handled = NO;
    
    NSInteger type = [self.shortcutIdentifiers indexOfObject:shortcutType];
    switch (type) {
        case 0:
            handled = YES;
            break;
        case 1:
            handled = YES;
            break;
        case 2:
            handled = YES;
            break;
        case 3:
            handled = YES;
            break;
            
        default:
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Shortcut Handled" message:shortcutItem.localizedTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    return handled;
}

@end
