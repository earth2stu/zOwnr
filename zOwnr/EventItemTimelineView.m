//
//  EventItemTimelineView.m
//  zOwnr
//
//  Created by Stuart Watkins on 9/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "EventItemTimelineView.h"
#import "EventItemViewController.h"
#import "UserMedia.h"
#import "UserMediaTimelineView.h"

@implementation EventItemTimelineView

@synthesize delegate;


- (id)initWithEventItem:(EventItem*)theItem pixelsPerHour:(NSNumber*)pph startTime:(NSDate*)sTime {
    self = [super init];
    if (self) {
        // Initialization code
        item = theItem;
        pixelsPerHour = pph;
        startTime = sTime;
        
        NSLog(@"adding event item");
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor redColor];
        //self.clipsToBounds = NO;
        titleLabel = [[UILabel alloc] init];
        titleLabel.text = item.name;
        [titleLabel setUserInteractionEnabled:YES];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEventItem:)];
        //tap.numberOfTapsRequired = 1;
        //tap.numberOfTouchesRequired = 1;
        //tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [titleLabel addGestureRecognizer:tap];
        [self addSubview:titleLabel];
        
        tickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tickButton setImage:[UIImage imageNamed:@"117-todo.png"] forState:UIControlStateNormal];
        [self addSubview:tickButton];
        
        
  //      eventItemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //eventItemButton.titleLabel.text = item.name;
  //      [eventItemButton setTitle:item.name forState:UIControlStateNormal];
  //      [eventItemButton addTarget:self action:@selector(selectEventItem:) forControlEvents:UIControlEventTouchUpInside];
  //      [self addSubview:eventItemButton];
        
        // work out the frame
        
        /*
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"hh";
        NSString *startHour = [f stringFromDate:item.startTime];
        NSString *endHour = [f stringFromDate:item.startTime];
        
        f.dateFormat = @"mm";
        NSString *startMin = [f stringFromDate:item.endTime];
        NSString *endMin = [f stringFromDate:item.endTime];
        
        
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterNoStyle;
        */
        
        [self setCurrentFrame:pixelsPerHour];
        
        
        
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

- (void)selectEventItem:(UIGestureRecognizer*)recognizer {
    [delegate selectEventItem:item fromFrame:visibleFrame];
    [self reloadMedia];
}

- (void)setCurrentFrame:(NSNumber*)pph {
    
    pixelsPerHour = pph;
    
    NSTimeInterval secondsPastStart = [item.startTime timeIntervalSinceDate:item.eventLocation.event.startTime];
    //NSLog(@"item=%@", item);
    //NSLog(@"loc=%@", item.eventLocation);
    //NSLog(@"event=%@", item.eventLocation.event);
    
    float hoursPastStart = secondsPastStart / 3600;
    float x = hoursPastStart * [pixelsPerHour floatValue];
    
    float secondsLong = [item.endTime timeIntervalSinceDate:item.startTime];
    float hoursLong = secondsLong / 3600;
    float width = hoursLong * [pixelsPerHour floatValue];
    
    [self setFrame:CGRectMake(x + kTLleftMargin, 0, width, kTLlocationHeight)];
    [titleLabel setFrame:CGRectMake(1, 0, width - 2, kTLlocationHeight)];
    //[eventItemButton setFrame:CGRectMake(1, 0, width - 2, 30)];
    
    if (width < 100) {
        [tickButton setHidden:YES];
    } else {
        [tickButton setHidden:NO];
        [tickButton setFrame:CGRectMake(width - 40, 5, 40, 40)];
    }
    
    
    if (userMediaViews) {
        [userMediaViews makeObjectsPerformSelector:@selector(setCurrentFrame:) withObject:pph];
    }

}

- (float)timeToPixels:(NSDate*)dateTime {
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didScroll:(UIScrollView *)scrollView {
    BOOL isInView = CGRectIntersectsRect(scrollView.bounds, self.frame);
    //NSLog(@"scrollview bounds=%@", NSStringFromCGRect(scrollView.bounds));
    //NSLog(@"my frame=%@", NSStringFromCGRect(self.frame));
    
    CGRect myFramePerScrollView = [self convertRect:self.frame toView:self.window];
    
    visibleFrame = CGRectIntersection(self.window.bounds, myFramePerScrollView);
    //
    
    if (isInView && !mediaIsLoaded) {
        
        [self reloadMedia];
    }
    
    if ([item.eventItemID intValue] == 18) {
        //NSLog(@"vis frame=%@", NSStringFromCGRect(myFramePerScrollView));
        //NSLog(@"event name=%@", item.name);
    }
}

- (void)reloadMedia {
    NSLog(@"event %i is in view .. loading media", [item.eventItemID intValue]);
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/eventItems/%@/usermedia", item.eventItemID] delegate:self];
    mediaIsLoaded = YES;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"loaded %i media objects", [objects count]);
    if ([objects count] > 0) {
        
        if (userMediaViews) {
            [userMediaViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [userMediaViews removeAllObjects];
        } else {
            userMediaViews = [[NSMutableArray alloc] init];
        }
        
        for (UserMedia *um in objects) {
            UserMediaTimelineView *v = [[UserMediaTimelineView alloc] initWithUserMedia:um pixelPerHour:pixelsPerHour];
            [self addSubview:v];
            [userMediaViews addObject:v];
        }
        
        //NSLog(@"woot");
    }
}

- (void)reapplyRecognizers {
    [self removeGestureRecognizer:tap];
    [titleLabel removeGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEventItem:)];
    [self addGestureRecognizer:tap];
    [titleLabel addGestureRecognizer:tap];
    
}

@end
