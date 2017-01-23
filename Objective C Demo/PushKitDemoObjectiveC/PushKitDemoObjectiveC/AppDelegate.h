//
//  AppDelegate.h
//  PushKitDemoObjectiveC
//
//  Created by Hasya.Panchasara on 23/01/17.
//  Copyright © 2017 Hasya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PushKit/PushKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,PKPushRegistryDelegate>
{
    PKPushRegistry *pushRegistry;
}

@property (strong, nonatomic) UIWindow *window;

@end

