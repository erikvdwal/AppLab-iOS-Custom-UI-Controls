//
//  CustomSegmentedControl.h
//  CustomSegmentedControl
//
//  Created by Erik van der Wal on 09-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSegmentedControl;

@interface CustomSegmentedControl : UIView {
    NSMutableArray *buttons;
    id controlTarget;
    SEL controlTargetAction;
}

@property (nonatomic) NSUInteger selectedSegmentIndex;

- (id)initWithItems:(NSArray *)segmentItems segmentSize:(CGSize)segmentSize segmentImages:(NSDictionary *)segmentImages capWidth:(NSUInteger)capWidth;
- (void)deselectAllButtonsExcept:(UIButton *)selectedButton;
- (void)setTarget:(id)target action:(SEL)action;
- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segmentIndex;
- (BOOL)isEnabledForSegmentAtIndex:(NSUInteger)segmentIndex;

@end
