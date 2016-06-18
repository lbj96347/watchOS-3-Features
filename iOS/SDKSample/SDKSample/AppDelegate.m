//
//  AppDelegate.m
//  SDKSample
//
//  Created by Djavan Bertrand on 24/02/2016.
//  Copyright © 2016 Parrot. All rights reserved.
//

#import "AppDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate ()<WCSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if([WCSession isSupported]){
        WCSession * session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - WatchSession Delegate Methods

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    NSLog(@"apple watch is sending message (no reply) : %@" , message);
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    NSNotificationCenter * nsnc = [NSNotificationCenter defaultCenter];

    if (message[@"altitude"]) {
        [nsnc postNotificationName:@"notificationAltitude" object:self userInfo:message];
    } else {
        [nsnc postNotificationName:@"notificationAcceleration" object:self userInfo:message];
    }


    /*
    if ( [message objectForKey:@"altitude"] ) {
        NSLog(@"apple watch is sending message %@" , message[@"altitude"]);
    }else{
        [nsnc postNotificationName:@"notificationAcceleration" object:self userInfo:message];
    }
     */
    //[nsnc postNotificationName:@"notificationReady" object:self userInfo:@{@"msg":@"ok"}];
    
}


@end