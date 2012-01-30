//
//  CustomRoundSwitch.h
//  CustomSwitch
//
//  Created by Erik van der Wal on 04-10-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomRoundSwitch : UIControl {
    BOOL tracking;
    CGFloat offsetX;
}

- (void)setOn:(BOOL)setToOn animated:(BOOL)animated;

@end
