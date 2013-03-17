/**
 * LFAFNetworkingInterface - This interface is used to wrap the AFNetworking interface to provide a set of methods that can be called through this to download and parse a JSON file, get images from a specific URL, write the images to the documents directory and then retrieve them when necessary. This is used mainly by the LFCollectionViewController and also by the the LFExpandedViewController when swiping between images. LFAppdelegate also uses this when the App comes back from background and checks to see if the images need to be re-downloaded incase the connection was lost.
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import "AFImageRequestOperation.h"
#import "LFParsingCompleteProtocol.h"
#import "LFPhotoCell.h"

@protocol LFParsingCompleteProtocol;
/** Created static instance so that this class can be statically called*/

@interface LFAFNetworkingInterface : AFImageRequestOperation <UIAlertViewDelegate>

/** Sends off a request to Af networking to get and parse the JSON data from image manifest, which is sent back through a delegate call
 */
+ (void)jsonRequestInitialiser;

/** Used to set the delegate for the ParsingComplete protocol, seeing as it is static so best way to set it
 @param id<ParsingComplete> The delegate class to call back
 */
+ (void)setImageManifestProtocol:(id<LFParsingCompleteProtocol>)delegate;

/**Returns an image if it is already saved in the documents directory, or if no image exists returns a place holder "No Image" Image!
 @param NSString The name of the image with MIME extension
 @return UIImage The image returned from documents directory if it exists
 */
+ (UIImage*) getSavedImageWithName:(NSString*) imageName;

/**This method encapsulates a request by the table view for an image kicking off Afnetworking downloader and storing image for later retrieval in the documents directory
 @param LFPhotoCell Cell we want to populate an image
 @param int Row number of the cell, so we know what image to populate
 @param NSArray Array of image URLS paths on the remote server that we retrieved from the JSON image manifest
 */
+ (void)requestImageForCell:(LFPhotoCell*)cell atRow:(int)row withImageURLS:(NSArray*)imageURLs;
@end
