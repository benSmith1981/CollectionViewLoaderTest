//
//  MGImageDownloadHandler.m
//  MGTest
//
//  Created by Ben on 23/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "MGAFNetworkingInterface.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"

static id<ParsingCompleteProtocol>parsingDelegate;

@interface MGAFNetworkingInterface ()
@end

@implementation MGAFNetworkingInterface

+ (void)jsonRequestInitialiser
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.wigtastic.com/MobGenImages/ImageManifest.json"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                        JSONRequestOperationWithRequest:request
                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                        NSLog(@"%@", JSON);
                                                                        //Get the image manifest dictionary
                                                                        NSDictionary *temp = [JSON objectForKey:@"image-manifest"];
                                                                        //Get the images array from dictionary
                                                                        NSArray *images = [temp objectForKey:@"images"];
                                                                        //Call to send back Image URLS array to delegate
                                                                        [parsingDelegate sendBackArrayOfImageURLs:images];
                                                                    }
                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                }];
    [operation start];

}

+ (void)setImageManifestProtocol:(id<ParsingCompleteProtocol>)delegate
{
    parsingDelegate = delegate;
}
@end
