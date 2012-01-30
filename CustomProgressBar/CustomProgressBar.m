//
//  CustomProgressBar.m
//  CustomProgressBar
//
//  Created by Erik van der Wal on 02-07-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomProgressBar.h"

@interface CustomProgressBar ()
@property (nonatomic, retain) UIImageView *progressBar;
@property (nonatomic, assign) CGFloat imageCapWidth;
@end

@implementation CustomProgressBar

@synthesize progress, progressBar, imageCapWidth;

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage barImage:(UIImage *)barImage capWidth:(CGFloat)capWidth;
{
    if (self == [self initWithFrame:frame])
    {
        self.imageCapWidth = capWidth;
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0]];
        [backgroundImageView setFrame:CGRectMake(0, 0, frame.size.width, backgroundImage.size.height)];
        [backgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
        
        UIImageView *barImageView = [[UIImageView alloc] initWithImage:[barImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0]];
        [barImageView setFrame:CGRectMake(0, 0, 32, barImageView.frame.size.height)];
        [barImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        self.progressBar = barImageView;
        [barImageView release];
        
        [self addSubview:self.progressBar];
    }
    
    return self;
}

- (void)setProgress:(CGFloat)amount animated:(BOOL)animated
{
    if (amount != progress)
    {        
        progress = (amount < 1.0 ? amount : 1.0);
        
        CGFloat minValue = self.imageCapWidth*2;
        CGFloat newWidth = ((self.frame.size.width-self.imageCapWidth) * amount) + self.imageCapWidth;
        
        if (newWidth <= minValue)
        {
            newWidth = minValue;
        }
        
        if (animated)
        {            
            [UIView animateWithDuration:0.75 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                CGRect frame = self.progressBar.frame;
                frame.size.width = newWidth;
                self.progressBar.frame = frame;
            } completion:nil];
        }
        else
        {
            [self.progressBar setFrame:CGRectMake(self.progressBar.frame.origin.x, self.progressBar.frame.origin.y, newWidth, self.progressBar.frame.size.height)];
        }
    }    
}

- (void)setProgress:(CGFloat)amount
{
    [self setProgress:amount animated:NO];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [progressBar release];
    [super dealloc];
}

@end
