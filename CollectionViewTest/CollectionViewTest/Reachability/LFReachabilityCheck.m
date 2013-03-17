/**
 * LFReachabilityCheck - This is a class that wraps the Apple Reachability class to check if the device is connected (called when there is a problem downloading the images or JSON) to the internet and then alert the user allowing them a chance to retry once connection has resumed.
 *
 * Created by Smith, Benjamin Terry on 3/14/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

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

+ (void) setAskedAboutConnection:(BOOL)asked{
    askedAboutConnection = asked;
}

#pragma mark - UIAlertViewDelegate method
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

@end
