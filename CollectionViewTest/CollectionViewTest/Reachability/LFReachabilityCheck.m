//
//  MGReachabilityCheck.m
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "LFReachabilityCheck.h"
#import "Reachability.h"
#import "LFAFNetworkingInterface.h"

static BOOL askedAboutConnection = NO;

@implementation LFReachabilityCheck

#pragma REACHIBILITY METHODS
+ (BOOL) connectedToNetwork
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.co.uk"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

+ (BOOL) checkInternet
{
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES)
	{
        if (!askedAboutConnection) {
            UIAlertView *alert = nil;
            
            alert = [[UIAlertView alloc] initWithTitle:@"No Network Connectivity!"
                                               message:@"No network connection found. An Internet connection is required for this application to work"
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"Retry", nil];
            [alert show];
            askedAboutConnection = TRUE;
        }
        return NO;
	}
	else {
        //we have a connection so return YES
		return YES;
	}
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //If connection fails restart the whole download from getting the JSON to then getting images, simplest way for now!
        //TODO would be better to make it so if it fails on an image it can retry for that image
        [LFAFNetworkingInterface jsonRequestInitialiser];
        askedAboutConnection = FALSE;
    }
    else {
        //reset the BOOL as user has cancelled but we want to beable to ask them to retry connecting should checkInternet get called again
        askedAboutConnection = TRUE;
    }
}

+ (void) setAskedAboutConnection:(BOOL)asked{
    askedAboutConnection = asked;
}
@end
