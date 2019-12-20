//
//  AppDelegate.m
//  QuestionDemo
//
//  Created by G on 2019/12/17.
//  Copyright © 2019 G. All rights reserved.
//

#import "AppDelegate.h"
#import "PageController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController: [PageController new]];
    controller.navigationBar.barTintColor = UIColor.whiteColor;
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - UISceneSession lifecycle

@end
