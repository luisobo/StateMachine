//
//  LSAppDelegate.h
//  StateMachineSample
//
//  Created by Luis Solano Bonet on 02/11/12.
//  Copyright (c) 2012 Luis Solano Bonet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSViewController;

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LSViewController *viewController;

@end
