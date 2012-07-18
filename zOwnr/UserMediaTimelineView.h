//
//  UserMediaTimelineView.h
//  zOwnr
//
//  Created by Stuart Watkins on 13/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMedia.h"
#import "EventItem.h"

@interface UserMediaTimelineView : UIView {
    UserMedia *userMedia;
}
- (id)initWithUserMedia:(UserMedia*)theUserMedia pixelPerHour:(NSNumber*)pph;
- (void)setCurrentFrame:(NSNumber*)pixelsPerHour;

@end
