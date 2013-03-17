/**
 * LFAFNetworkingInterface - This interface is used to wrap the AFNetworking interface to provide a set of methods that can be called through this to download and parse a JSON file, get images from a specific URL, write the images to the documents directory and then retrieve them when necessary. This is used mainly by the LFCollectionViewController and also by the the LFExpandedViewController when swiping between images. LFAppdelegate also uses this when the App comes back from background and checks to see if the images need to be re-downloaded incase the connection was lost.
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import "AFJSONRequestOperation.h"
#import "LFConstants.h"
#import "AFNetworking.h"
#import "LFAFNetworkingInterface.h"
#import "LFReachabilityCheck.h"
#import "LFConstants.h"

static id<LFParsingCompleteProtocol>parsingDelegate;

@interface LFAFNetworkingInterface ()
//static NSArray *imageURLsStatic;

/**Returns the image directory path that we store our images in
 @return NSString The image directory path for images
 */
+ (NSString*)getOurImageDirectory;

/**Writes the image data to a specific file location in our documents directory for later retrieval
 @param NSString This is the image path in documents directory
 @param UIImage This is the image we want to save there
 */
+ (void)writeImages:(NSString*)imageStringURL DataToFile:(UIImage*)image;
@end

@implementation LFAFNetworkingInterface

+ (void)jsonRequestInitialiser
{
    NSURL *url = [[NSURL alloc] initWithString:imageManifestJSON];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                             //Get the image manifest dictionary
                                             NSDictionary *temp = [JSON objectForKey:@"image-manifest"];
                                             //Get the images array from dictionary
                                             NSArray *images = [temp objectForKey:@"images"];
                                             //Call to send back Image URLS array to delegate
                                             [parsingDelegate sendBackArrayOfImageURLs:images];
                                             
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             //check validity of JSON before attempting to Parse it
                                             BOOL valid = [NSJSONSerialization isValidJSONObject:JSON];
                                             
                                             //print error to console
                                             NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);

                                             if (valid) {
                                             //perform a reachability check if the JSON is actually valid, and present user with options
                                             [LFReachabilityCheck checkInternet];
                                                 
                                             }
                                             else
                                             {
                                                 //if the json is invalid display user a UIAlertView message, and close app when they press button
                                                 UIAlertView *alert = nil;
                                                 alert = [[UIAlertView alloc] initWithTitle:@"Invalid JSON"
                                                                                    message:@"Sorry the JSON manifest used to download images is corrupted, we cannot get the images, please contact the vendor at benjaminsmith1981@gmail.com"
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"Close App"
                                                                          otherButtonTitles:nil, nil];
                                                 [alert show];
                                             }
                                         }];
    [operation start];
}

+ (void)requestImageForCell:(LFPhotoCell*)cell atRow:(int)row withImageURLS:(NSArray*)imageURLs
{
    NSURL *url = [[NSURL alloc]initWithString:[imageURLs objectAtIndex:row]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    //put in our NSURL request to the AFnetworking method to retrieve the image, but use a placeholder until it has
    __weak LFPhotoCell* weakCell = cell; //need to create a weak cell to stop retain cycle in following block
    [weakCell.cellImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"loading.png"]
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                                 {
                                     //Upon successful retrieval set the collection view image to that retrieved
                                     weakCell.cellImageView.image = image;
                                     
                                     //weakCell.cellImageView.contentMode = UIViewContentModeScaleAspectFill;
                                     //Then on a background thread write this image to our docs directory for permanent storage
                                     
                                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                         [self writeImages:[imageURLs objectAtIndex:row] DataToFile:image];
                                     });
                                 }
                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                                 {
                                     //if retrieval fails print error description
                                     NSLog(@"%@",error.description);
                                     
                                     //Something went wrong getting the image, it wasn't there so a placeholder (no image) is shown instead
                                     weakCell.cellImageView.image = [UIImage imageNamed:@"no_image.jpg"];
                                     
                                     //check to see if it was an internet problem
                                     if ([LFReachabilityCheck checkInternet]) {
                                         
                                         //if it isn't an internet issue tell the user one image could not be retrieved
                                         UIAlertView *alert = nil;
                                         alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Image %@ could not be downloaded",[[imageURLs objectAtIndex:row]lastPathComponent]]
                                                                            message:@"An image seems to be missing, please contact the vendor at benjaminsmith1981@gmail.com"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                                         [alert show];
                                     }
                                 }];
}

+ (void)setImageManifestProtocol:(id<LFParsingCompleteProtocol>)delegate
{
    parsingDelegate = delegate;
}

+ (void)writeImages:(NSString*)imageStringURL DataToFile:(UIImage*)image
{
    //if image doesn't exist then save it in documents directory
    if (![self doesImageExist:imageStringURL])
    {
        // Save Image
        NSData *imageData = UIImageJPEGRepresentation(image, 90);
        //write to documents directory
        [imageData writeToFile:[NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],[imageStringURL lastPathComponent]] atomically:YES];
    }
}

+ (NSString*)getOurImageDirectory
{
    // Get dir
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    
    //Concatenate a path string with our documentsdirectory path and return this to caller
    NSString *pathString = [NSString stringWithFormat:@"%@/",documentsDirectory];
    return pathString;
}

+ (BOOL)doesImageExist:(NSString*)imageName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Get full path with our image name on the end
    NSString *str = [NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],imageName];
    
    //Using the NSFileManager method check if a file exists at this path and return YES or NO to the caller in writeImages and getSavedImageWithName method
    return [fileManager fileExistsAtPath:str];
}

+ (UIImage*) getSavedImageWithName:(NSString*) imageName
{
    UIImage* image = nil;
    //if image exists
    if([self doesImageExist:imageName])
    {
        //make up full path
        NSString *fullImagePath = [NSString stringWithFormat:@"%@%@",[self getOurImageDirectory],imageName];
        
        //intialise image object with the contents of this image path, basically the image stored in our doc directory
        image = [[UIImage alloc] initWithContentsOfFile:fullImagePath];
    }
    else {
        //If there is no image return no image jpg
        image = [UIImage imageNamed:@"no_image.jpg"];
    }
    return image;
}

#pragma mark - UIAlertViewDelegate method
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //concatenate message to show future developer in console 
    NSString *message = [NSString stringWithFormat:@"The JSON file at %@ is invalid, please check this file",imageManifestJSON];
    
    //If we get here then the app must throw an assertion and crash
    NSAssert(NO,message);
}

@end
