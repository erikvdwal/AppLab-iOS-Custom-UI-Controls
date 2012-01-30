//
//  CustomProgressBar.h
//  CustomProgressBar
//
//  Created by Erik van der Wal on 02-07-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomProgressBar : UIView {
    
}

@property (nonatomic, readonly) CGFloat progress;

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage barImage:(UIImage *)barImage capWidth:(CGFloat)capWidth;
- (void)setProgress:(CGFloat)amount;
- (void)setProgress:(CGFloat)amount animated:(BOOL)animated;

@end