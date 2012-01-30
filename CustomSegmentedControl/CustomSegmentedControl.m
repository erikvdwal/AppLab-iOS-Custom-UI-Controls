//
//  CustomSegmentedControl.m
//  CustomSegmentedControl
//
//  Created by Erik van der Wal on 09-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentedControl.h"

typedef enum {
    CapLeft         = 0,
    CapMiddle       = 1,
    CapRight        = 2,
    CapLeftAndRight = 3
} CapLocation;

@interface UIImage (PrivateMethods)
- (UIImage *)capWithImage:(UIImage *)capImage capWidth:(NSUInteger)capWidth capLocation:(CapLocation)location;
@end

@implementation UIImage (PrivateMethods)

- (UIImage *)capWithImage:(UIImage *)capImage capWidth:(NSUInteger)capWidth capLocation:(CapLocation)location
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, 0.0);
    
    if (location == CapLeft)
    {
        [self drawInRect:CGRectMake(capImage.size.width, 0.0, self.size.width-capWidth, self.size.height)];
        [capImage drawInRect:CGRectMake(0.0, 0.0, capImage.size.width, capImage.size.height)];
    }
    else if (location == CapRight)
    {
        [self drawInRect:CGRectMake(0.0, 0.0, self.size.width-capWidth, self.size.height)];
        [capImage drawInRect:CGRectMake(self.size.width-capWidth, 0.0, capImage.size.width, capImage.size.height)];
        
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end

@interface CustomSegmentedControl (PrivateMethods)
- (UIImage *)buttonImage:(UIImage *)buttonImage withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;
- (UIImage *)capImage:(UIImage *)capImage withCap:(CapLocation)location capWidth:(NSUInteger)capWidth;
@end

@implementation CustomSegmentedControl

@synthesize selectedSegmentIndex;

- (id)initWithItems:(NSArray *)segmentItems segmentSize:(CGSize)segmentSize segmentImages:(NSDictionary *)segmentImages capWidth:(NSUInteger)capWidth
{
    self = [super init];
    if (self)
    {
        [self setFrame:CGRectMake(0, 0, [segmentItems count]*segmentSize.width, segmentSize.height)];
        
        buttons = [[NSMutableArray alloc] initWithCapacity:[segmentItems count]];
        
        UIImage *backgroundImage = [UIImage imageNamed:[segmentImages valueForKey:@"backgroundImage"]];
        UIImage *backgroundImageSelected = [UIImage imageNamed:[segmentImages valueForKey:@"backgroundImageSelected"]];
        
        UIImage *capImage = [UIImage imageNamed:[segmentImages valueForKey:@"roundedImage"]];
        UIImage *capImageSelected = [UIImage imageNamed:[segmentImages valueForKey:@"roundedImageSelected"]];
        
        CapLocation capLocation;
        
        UIImage *cappedImage;
        UIImage *cappedImageSelected;
        
        for (int i = 0; i < [segmentItems count]; i++)
        {
            capLocation = CapMiddle;
            
            if (i == 0)
            {
                capLocation = ([segmentItems count] == 1? CapLeftAndRight : CapLeft);
            }
            else if (i == ([segmentItems count]-1))
            {
                capLocation = CapRight;
            }
            else if (i == ([segmentItems count]-2))                
            {
                capLocation = CapLeftAndRight;
            }
            
            UIImage *buttonBackgroundImage = [self buttonImage:backgroundImage withCap:capLocation capWidth:capWidth buttonWidth:segmentSize.width];            
            UIImage *buttonBackgroundImageSelected = [self buttonImage:backgroundImageSelected withCap:capLocation capWidth:capWidth buttonWidth:segmentSize.width];
            
            if (capLocation == CapLeft || capLocation == CapRight)
            {
                // Generate a cap image based on the given location
                cappedImage = [self capImage:capImage withCap:capLocation capWidth:capWidth];
                cappedImageSelected = [self capImage:capImageSelected withCap:capLocation capWidth:capWidth];                
                
                // Add cap image to the given side
                buttonBackgroundImage = [buttonBackgroundImage capWithImage:cappedImage capWidth:capWidth capLocation:capLocation];
                buttonBackgroundImageSelected = [buttonBackgroundImageSelected capWithImage:cappedImageSelected capWidth:capWidth capLocation:capLocation];
            }
            
            if ([segmentItems count] == 1)
            {
                // Just turn the rounded (cap)image into a stretchable image.
                buttonBackgroundImage = [capImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
                buttonBackgroundImageSelected = [capImageSelected stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
            }
            
            UIButton *segmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [segmentButton setFrame:CGRectMake(i*segmentSize.width, (self.frame.size.height-segmentSize.height)/2, segmentSize.width, segmentSize.height)];
            [segmentButton setTitle:[[segmentItems objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];

            [segmentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [segmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [segmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [segmentButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
            [segmentButton setBackgroundImage:buttonBackgroundImageSelected forState:UIControlStateSelected];
            [segmentButton setBackgroundImage:buttonBackgroundImageSelected forState:UIControlStateHighlighted];
            
            [[segmentButton titleLabel] setFont:[UIFont boldSystemFontOfSize:13.0]];
            [[segmentButton titleLabel] setShadowColor:[UIColor blackColor]];
            [[segmentButton titleLabel] setShadowOffset:CGSizeMake(0, 1)];
            
            [segmentButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
            
            [segmentButton addTarget:self action:@selector(deselectAllButtonsExcept:) forControlEvents:UIControlEventTouchDown];
            [segmentButton addTarget:self action:@selector(deselectAllButtonsExcept:) forControlEvents:UIControlEventTouchUpInside];
            [segmentButton addTarget:self action:@selector(deselectAllButtonsExcept:) forControlEvents:UIControlEventTouchUpOutside];
            [segmentButton addTarget:self action:@selector(deselectAllButtonsExcept:) forControlEvents:UIControlEventTouchDragInside];
            [segmentButton addTarget:self action:@selector(deselectAllButtonsExcept:) forControlEvents:UIControlEventTouchDragOutside];
            
            [self addSubview:segmentButton];
            [buttons addObject:segmentButton];
        }
        
        [self deselectAllButtonsExcept:[buttons objectAtIndex:0]];
    }
    
    return self;
}

- (UIImage *)buttonImage:(UIImage *)buttonImage withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIImage *stretchedButtonImage = [buttonImage stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, buttonImage.size.height), NO, 0.0);
    
    if (location == CapLeft || location == CapMiddle)
    {
        [stretchedButtonImage drawInRect:CGRectMake(0.0-capWidth, 0.0, buttonWidth+capWidth, buttonImage.size.height)];
    }
    else if (location == CapLeftAndRight)
    {
        [stretchedButtonImage drawInRect:CGRectMake(0.0-capWidth, 0.0, buttonWidth+(capWidth*2), buttonImage.size.height)];
    }
    else if (location == CapRight)
    {
        [stretchedButtonImage drawInRect:CGRectMake(0.0, 0.0, buttonWidth+capWidth, buttonImage.size.height)];
    }
    
    UIImage *cappedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cappedImage;
}

- (UIImage *)capImage:(UIImage *)capImage withCap:(CapLocation)location capWidth:(NSUInteger)capWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(capWidth, capImage.size.height), NO, 0.0);
    
    if (location == CapLeft)
    {
        [capImage drawInRect:CGRectMake(0.0, 0.0, capImage.size.width, capImage.size.height)];
    }
    else if (location == CapRight)
    {
        [capImage drawInRect:CGRectMake(0.0-(capImage.size.width-capWidth), 0.0, capImage.size.width, capImage.size.height)];
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (void)deselectAllButtonsExcept:(UIButton *)selectedButton
{
    for (UIButton *button in buttons)
    {
        if (button == selectedButton)
        {
            [button setSelected:YES];
            [button setHighlighted:button.selected ? NO : YES];
            
            if (self.selectedSegmentIndex != [buttons indexOfObject:selectedButton])
            {
                self.selectedSegmentIndex = [buttons indexOfObject:selectedButton];
                [controlTarget performSelector:controlTargetAction withObject:self];
            }
        }
        else
        {
            [button setSelected:NO];
            [button setHighlighted:NO];
        }
    }
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segmentIndex
{
    [[buttons objectAtIndex:segmentIndex] setEnabled:enabled];
}

- (BOOL)isEnabledForSegmentAtIndex:(NSUInteger)segmentIndex
{
    return [[buttons objectAtIndex:segmentIndex] isEnabled];
}

- (void)setTarget:(id)target action:(SEL)action
{
    controlTarget = target;
    controlTargetAction = action;
}

- (void)dealloc
{
    [buttons release];
    [super dealloc];
}

@end
