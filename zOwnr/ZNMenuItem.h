//
//  ZNMenuItem.h
//  zOwnr
//
//  Created by Stuart Watkins on 25/07/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMenuTargetBase,
    kMenuTargetMap,
    kMenuTargetTimeline,
    kMenuTargetSocial,
    kMenuTargetMedia,
    kMenuTargetSettings
} kMenuTarget;

@interface ZNMenuItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (assign) SEL selector;
@property (assign) kMenuTarget target;
@property (nonatomic, retain) id selectedItem;

- (id)initWithTitle:(NSString*)itemTitle andTarget:(kMenuTarget)itemTarget andSelector:(SEL)itemSelector andSelected:(id)itemSelected;

@end
