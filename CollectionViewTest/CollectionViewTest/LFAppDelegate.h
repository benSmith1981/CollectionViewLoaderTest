/**
 * LFAppDelegate - The appdelegate to setup the the app and main View Controller. Contains instruction in the applicationWillEnterForeground:application to redownload the JSON and any images and then any subsequent images that weren't retrieved due to poor connection or non at all.

 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@class LFCollectionViewController;

@interface LFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LFCollectionViewController *viewController;

@end
