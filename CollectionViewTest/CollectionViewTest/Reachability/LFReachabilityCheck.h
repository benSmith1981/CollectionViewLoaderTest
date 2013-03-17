/**
 * LFReachabilityCheck - This is a class that wraps the Apple Reachability class to check if the device is connected (called when there is a problem downloading the images or JSON) to the internet and then alert the user allowing them a chance to retry once connection has resumed.
 *
 * Created by Smith, Benjamin Terry on 3/14/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "LFCollectionViewController.h"

@interface LFReachabilityCheck : NSObject <UIAlertViewDelegate>

@property(nonatomic,strong)LFCollectionViewController *collectionVC;
          
/**
 Are we connected to a network, finds out what type of network
 */
+ (BOOL) connectedToNetwork;

/**
 Checks for internet connection and presents user with message to retry
 */
+ (BOOL) checkInternet;

/**
 Sets the static variable whether the user has been asked about connecting
 */
+ (void) setAskedAboutConnection:(BOOL)asked;

@end
