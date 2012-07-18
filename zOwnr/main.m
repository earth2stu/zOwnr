//
//  main.m
//  zOwnr
//
//  Created by Stuart Watkins on 11/04/12.
//  Copyright (c) 2012 Cytrasoft Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZNAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        
        NSString *classString = NSStringFromClass([ZNAppDelegate class]);
        @try {
            retVal = UIApplicationMain(argc, argv, nil, classString);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception - %@",[exception description]);
            exit(EXIT_FAILURE);
        }
        return retVal;
        
        //return UIApplicationMain(argc, argv, nil, NSStringFromClass([ZNAppDelegate class]));
    }
}
