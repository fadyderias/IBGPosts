//
//  AppDelegate.m
//  IBGPosts
//
//  Created by Fady on 6/16/18.
//  Copyright © 2018 Instabug. All rights reserved.
//

#import "AppDelegate.h"
#import "PostsTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupApplicationWindow];
    [self setupApplicationRootViewController];
    return YES;
}

- (void)setupApplicationWindow {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)setupApplicationRootViewController {
    PostsTableViewController *postsViewController = [[PostsTableViewController alloc] init];
    UINavigationController *rootNavigationViewController = [[UINavigationController alloc] initWithRootViewController:postsViewController];
    self.window.rootViewController = rootNavigationViewController;
}

@end
