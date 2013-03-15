//
//  CloseExpandedViewProtocol.h
//  CollectionViewTest
//
//  Created by Smith, Benjamin Terry on 3/13/13.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Use this protocol to close the LFExpandedCellViewController*/
@protocol CloseExpandedViewProtocol <NSObject>

/**Animates closing of the expanded view controller
 */
-(void)expandedViewControlledClosed;
@end
