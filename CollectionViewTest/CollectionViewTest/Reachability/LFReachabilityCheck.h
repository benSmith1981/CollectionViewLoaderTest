//
//  MGReachabilityCheck.h
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
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
@end
