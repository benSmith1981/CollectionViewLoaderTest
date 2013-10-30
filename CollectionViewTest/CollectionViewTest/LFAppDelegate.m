//
//  AppDelegate.m
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/12/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "LFAppDelegate.h"

#import "LFCollectionViewController.h"
#import "TestFlight.h"
#import "LFReachabilityCheck.h"
#import "LFAFNetworkingInterface.h"

@implementation LFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Setup our testflight token so we can push builds to testflight
    [TestFlight takeOff:@"59767a0b-3c07-4d05-b07d-0812d3cf7019"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Create our LFCollectionViewController intialising with the UICollectionViewFlowLayout so the cells flow nicely in and ordered way across the view
    self.viewController = [[LFCollectionViewController alloc] initWithNibName:@"LFCollectionViewController" bundle:nil];
    
    //Set the root window to that of UIScreen mainScreen bounds so that even on different sized screens (such as iphone 5) the main screen and all subsequent view controllers will also scale to this size
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //set root window to that of our LFCollectionViewController
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //Reset the AskedAboutConnection BOOL so if the internet is off we can ask user to retry connecting, if we don't reset this static method then the user will never be asked to retry downloading if they had cancelled trying to download, then backgrounded the app to sort out the connection and then brought it back
    [LFReachabilityCheck setAskedAboutConnection:NO];
    
    //Set off JSON request incase this failed due to poor connection or we need to reload images if JSON has been added to
    [LFAFNetworkingInterface jsonRequestInitialiser];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
