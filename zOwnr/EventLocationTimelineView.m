//
//  EventLocationTimelineView.m
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventLocationTimelineView.h"

@implementation EventLocationTimelineView

@synthesize delegate;
@synthesize isSelected;
@synthesize index;

- (id)initWithLocation:(EventLocation*)theLocation frame:(CGRect)frame pixelsPerHour:(NSNumber*)pph startTime:(NSDate*)sTime {
    self = [super initWithFrame:frame];
    if (self) {
        location = theLocation;
        startTime = sTime;
        pixelsPerHour = pph;
        
        NSLog(@"adding event location line");
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        nameLabel.text = location.name;
        [self addSubview:nameLabel];
        
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
        
        itemViews = [[NSMutableArray alloc] init];
        
        for (EventItem *item in location.eventItems) {
            EventItemTimelineView *itv = [[EventItemTimelineView alloc] initWithEventItem:item pixelsPerHour:pixelsPerHour startTime:startTime];
            itv.delegate = self;
            [self addSubview:itv];
            [itemViews addObject:itv];
        }
        
        NSLog(@"done location");
        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)deselect {
    isSelected = NO;
}



- (void)setBounds:(CGRect)bounds {
    NSLog(@"bounds set");
    [super setBounds:bounds];
}

- (void)setCenter:(CGPoint)center {
    NSLog(@"set centre");
    [super setCenter:center];
}

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor {
    NSLog(@"set scale factor");
    [super setContentScaleFactor:contentScaleFactor];
}

- (void)setFrame:(CGRect)frame {
    NSLog(@"set frame");
    [super setFrame:frame];
}

- (void)updatePixelsPerHour:(NSNumber*)pph {
    pixelsPerHour = pph;
    [itemViews makeObjectsPerformSelector:@selector(setCurrentFrame:) withObject:pixelsPerHour];
}


- (void)setTransform:(CGAffineTransform)newValue
{
    NSLog(@"set transform");
    //CGAffineTransform constrainedTransform = CGAffineTransformIdentity;
    //constrainedTransform.a = newValue.a;
    nameLabel.transform = CGAffineTransformIdentity;
    [super setTransform:newValue];
}

- (void)selectEventItem:(EventItem *)e fromFrame:(CGRect)fromFrame {
    [delegate selectEventItem:e fromFrame:fromFrame inLocationView:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didScroll:(UIScrollView*)scrollView {
    [itemViews makeObjectsPerformSelector:@selector(didScroll:) withObject:scrollView];
}

- (void)reapplyRecognizers {
    [itemViews makeObjectsPerformSelector:@selector(reapplyRecognizers)];
}

@end
