/**
 * CloseExpandedViewProtocol - This protocl is used by the LFExpandedCellViewController to call back to its parent class to close and remove itself
 * from the view, as the responsibility for closing a class should lie in the parent view controller
 *
 * Created by Smith, Benjamin Terry on 3/12/13.
 * Copyright (c) 2013 Ben Smith. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/** Use this protocol to close the LFExpandedCellViewController*/
@protocol LFCloseExpandedViewProtocol <NSObject>

/**Animates closing of the expanded view controller
 */
-(void)expandedViewControlledClosed;
@end
