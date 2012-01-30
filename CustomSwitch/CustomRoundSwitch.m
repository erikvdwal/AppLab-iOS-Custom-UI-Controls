//
//  CustomRoundSwitch.m
//  CustomSwitch
//
//  Created by Erik van der Wal on 04-10-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomRoundSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomRoundSwitch()

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIImageView *thumbView;
@property (nonatomic, retain) UIImageView *maskView;
@property (nonatomic, assign) BOOL on;

- (void)moveToXPoint:(CGFloat)x animated:(BOOL)animated;
- (void)toggle;

@end


@implementation CustomRoundSwitch

@synthesize backgroundView;
@synthesize backgroundImage;
@synthesize thumbView;
@synthesize maskView;
@synthesize on;

- (void)dealloc
{
    [maskView release];
    [thumbView release];
    [backgroundView release];
    [super dealloc];
}

- (id)init
{
    if ((self = [self initWithFrame:CGRectMake(20.0, 20.0, 66.0, 25.0)]))
    {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 65.0, 24.0)];
        [backgroundView setUserInteractionEnabled:NO];
        [[backgroundView layer] setMasksToBounds:YES];
        [[backgroundView layer] setCornerRadius:12.0];
        
        backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch_bg.png"]];
        [backgroundImage setUserInteractionEnabled:NO];
        [backgroundView addSubview:backgroundImage];
        [backgroundImage release];
        
        UIImage *maskImage = [[UIImage imageNamed:@"switch_mask.png"] stretchableImageWithLeftCapWidth:16.0 topCapHeight:0.0];
        maskView = [[UIImageView alloc] initWithImage:maskImage];
        [maskView setFrame:CGRectMake(0.0, 0.0, 65.0, 25.0)];
        
        thumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"switch_thumb.png"]];
        [thumbView setFrame:CGRectMake(0.0, -1.0, [thumbView frame].size.width, [thumbView frame].size.height)];
        [thumbView setUserInteractionEnabled:NO];
        
        [backgroundImage setCenter:CGPointMake([thumbView center].x, [backgroundImage center].y)];
        
        [self addSubview:backgroundView];
        [self addSubview:maskView];
        [self addSubview:thumbView];
    }
    
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    if (CGRectContainsPoint([thumbView frame], [touch locationInView:self]))
    {
        tracking = YES;
        offsetX = [touch locationInView:thumbView].x - ([thumbView frame].size.width/2);
    }
    else
    {
        tracking = NO;
        offsetX = 0;
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    if (tracking == NO) return NO;
        
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat newPosition = touchPoint.x - offsetX;
    CGFloat newMaxX = newPosition + ([thumbView frame].size.width/2);
    CGFloat newMinX = newPosition - ([thumbView frame].size.width/2);
    
    CGFloat boundsMaxX = CGRectGetMaxX([self bounds]);
    CGFloat boundsMinX = CGRectGetMinX([self bounds]);
        
    if (newMaxX <= boundsMaxX && newMinX >= boundsMinX)
    {
        [self moveToXPoint:newPosition animated:NO];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{    
    [super endTrackingWithTouch:touch withEvent:event];
   
    if (tracking == NO) return;
            
    CGFloat middleX = [self frame].size.width/2;
    
    if ([thumbView center].x >= middleX)
    {
        [self setOn:YES animated:YES];
    }
    else
    {
        [self setOn:NO animated:YES];
    }
}

- (void)moveToXPoint:(CGFloat)x animated:(BOOL)animated
{
    if (!animated)
    {
        [thumbView setCenter:CGPointMake(x, [thumbView center].y)];
        [backgroundImage setCenter:CGPointMake(x, [backgroundImage center].y)];        
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [thumbView setCenter:CGPointMake(x, [thumbView center].y)];
            [backgroundImage setCenter:CGPointMake(x, [backgroundImage center].y)];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setOn:(BOOL)setToOn animated:(BOOL)animated
{
    CGFloat newX;
    
    if (setToOn == YES)
    {
        newX = CGRectGetWidth([self bounds]) - (CGRectGetWidth([thumbView frame])/2);
    }
    else
    {
        newX = CGRectGetMinX([self bounds]) + (CGRectGetWidth([thumbView frame])/2);
    }
        
    if (animated)
    {
        [UIView animateWithDuration:0.235 animations:^{
            [thumbView setCenter:CGPointMake(newX, [thumbView center].y)];
            [backgroundImage setCenter:CGPointMake(newX, [backgroundImage center].y)];    
        } completion:^(BOOL finished) {
            on = setToOn;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }];
    }
    else
    {
        on = setToOn;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        [thumbView setCenter:CGPointMake(newX, [thumbView center].y)];
        [backgroundImage setCenter:CGPointMake(newX, [backgroundImage center].y)];
    }
}

- (void)toggle
{
	[self setOn:![self on] animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([touches count] == 1 && [event type] == UIEventTypeTouches && tracking == NO)
    {
        [self toggle];
    }
}

@end
