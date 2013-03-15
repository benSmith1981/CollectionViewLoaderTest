//
//  LFReachabilityCheck.h
//  CollectionViewLoaderTest
//
//  Created by Ben on 14/03/2013.
//  

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
