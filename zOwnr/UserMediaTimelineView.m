//
//  UserMediaTimelineView.m
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import "UserMediaTimelineView.h"

@implementation UserMediaTimelineView

- (id)initWithUserMedia:(UserMedia*)theUserMedia pixelPerHour:(NSNumber*)pph {
    self = [super init];
    if (self) {
        
        userMedia = theUserMedia;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.png"]];
        [icon setFrame:CGRectMake(0, -32, 32, 37)];
        [self addSubview:icon];
        
        // Initialization code
        [self setCurrentFrame:pph];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCurrentFrame:(NSNumber*)pixelsPerHour {
    
    NSTimeInterval secondsPastStart = [userMedia.captureTime timeIntervalSinceDate:userMedia.eventItem.startTime];
    
    float hoursPastStart = secondsPastStart / 3600;
    float x = (hoursPastStart * [pixelsPerHour floatValue]) - 16;
    
    [self setFrame:CGRectMake(x, 0, 32, 37)];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
