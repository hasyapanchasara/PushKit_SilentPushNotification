//
//  AppDelegate.swift
//  PushDemo
//
//  Created by Hasya.Panchasra on 01/07/16.
//  Copyright © 2016 bv. All rights reserved.
//

import UIKit
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,PKPushRegistryDelegate {

    var window: UIWindow?

    var isUserHasLoggedInWithApp: Bool = true
    var checkForIncomingCall: Bool = true
    var userIsHolding: Bool = true

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

               
        let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
        application.registerForRemoteNotificationTypes(types)
        
        self.PushKitRegistration()
        
        return true
    }
    
    //MARK: - PushKitRegistration
    
    func PushKitRegistration()
    {
        
        let mainQueue = dispatch_get_main_queue()
        // Create a push registry object
        if #available(iOS 8.0, *) {
            
            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
            
            // Set the registry's delegate to self
            
            voipRegistry.delegate = self
            
            // Set the push type to VoIP
            
            voipRegistry.desiredPushTypes = [PKPushTypeVoIP]
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    @available(iOS 8.0, *)
    func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
        // Register VoIP push token (a property of PKPushCredentials) with server
        
        let hexString : String = UnsafeBufferPointer<UInt8>(start: UnsafePointer(credentials.token.bytes),
            count: credentials.token.length).map { String(format: "%02x", $0) }.joinWithSeparator("")
        
        print(hexString)
        
        
    }
    
    
    @available(iOS 8.0, *)
    func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        
        // Process the received push
        
        // Below process is specific to schedule local notification once pushkit payload received
        
        var arrTemp = [NSObject : AnyObject]()
        arrTemp = payload.dictionaryPayload
        
        let dict : Dictionary <String, AnyObject> = arrTemp["aps"] as! Dictionary<String, AnyObject>
        
        
        if isUserHasLoggedInWithApp // Check this flag then only proceed
        {
            
            if UIApplication.sharedApplication().applicationState == UIApplicationState.Background || UIApplication.sharedApplication().applicationState == UIApplicationState.Inactive
            {
                
                if checkForIncomingCall // Check this flag to know incoming call or something else
                {
                    
                    var strTitle : String = dict["alertTitle"] as? String ?? ""
                    let strBody : String = dict["alertBody"] as? String ?? ""
                    strTitle = strTitle + "\n" + strBody
                    
                    let notificationIncomingCall = UILocalNotification()
                    
                    notificationIncomingCall.fireDate = NSDate(timeIntervalSinceNow: 1)
                    notificationIncomingCall.alertBody =  strTitle
                    notificationIncomingCall.alertAction = "Open"
                    notificationIncomingCall.soundName = "SoundFile.mp3"
                    notificationIncomingCall.category = dict["category"] as? String ?? ""

                    //"As per payload you receive"
                    notificationIncomingCall.userInfo = ["key1": "Value1"  ,"key2": "Value2" ]

                    
                    UIApplication.sharedApplication().scheduleLocalNotification(notificationIncomingCall)
                    
                }
                else
                {
                    //  something else
                }
                
            }
        }
        
        
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

