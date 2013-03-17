/**
 * LFParsingCompleteProtocol - This is implemented by the LFCollectionViewController, so that once the JSON has been downloaded and parsed the LFCollectionViewController can then kick off the download of the Images through being asked to reload the data.
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
/** Implement this to get JSON data back in form of and array*/
@protocol LFParsingCompleteProtocol <NSObject>

/**Protocol method used to send back JSON data to class that requested it
 @param NSArray of image urls to be downloaded to display in table
 */
- (void) sendBackArrayOfImageURLs:(NSArray*)imageURLs;
@end
