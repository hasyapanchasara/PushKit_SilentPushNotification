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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

               
        if #available(iOS 8.0, *){
            
            
            let viewAccept = UIMutableUserNotificationAction()
            viewAccept.identifier = "VIEW_ACCEPT"
            viewAccept.title = "Accept"
            viewAccept.activationMode = .foreground
            viewAccept.isDestructive = false
            viewAccept.isAuthenticationRequired =  false
            
            let viewDecline = UIMutableUserNotificationAction()
            viewDecline.identifier = "VIEW_DECLINE"
            viewDecline.title = "Decline"
            viewDecline.activationMode = .background
            viewDecline.isDestructive = true
            viewDecline.isAuthenticationRequired = false
            
            let INCOMINGCALL_CATEGORY = UIMutableUserNotificationCategory()
            INCOMINGCALL_CATEGORY.identifier = "INCOMINGCALL_CATEGORY"
            INCOMINGCALL_CATEGORY.setActions([viewAccept,viewDecline], for: .default)
            
            if application.responds(to: #selector(getter: UIApplication.isRegisteredForRemoteNotifications))
            {
                let categories = NSSet(array: [INCOMINGCALL_CATEGORY])
                let types:UIUserNotificationType = ([.alert, .sound, .badge])
                
                let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: categories as? Set<UIUserNotificationCategory>)
                
                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }
            
        }
        else{
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }

        
        self.PushKitRegistration()
        
        return true
    }
    
    //MARK: - PushKitRegistration
    
    func PushKitRegistration()
    {
        
        let mainQueue = DispatchQueue.main
        // Create a push registry object
        if #available(iOS 8.0, *) {
            
            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
            
            // Set the registry's delegate to self
            
            voipRegistry.delegate = self
            
            // Set the push type to VoIP
            
            voipRegistry.desiredPushTypes = [PKPushType.voIP]
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    @available(iOS 8.0, *)
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        // Register VoIP push token (a property of PKPushCredentials) with server
        
        print(credentials.token)

        // Swift 2 format
//        let hexString : String = UnsafeBufferPointer<UInt8>(start: UnsafePointer(credentials.token.bytes),
//                                                            count: credentials.token.length).map { String(format: "%02x", $0) }.joinWithSeparator("")
        
        // Swift 4 format
        
        let token = credentials.token.map { String(format: "%02x", $0) }.joined()
        print(token)
        
    }
    
    
    @available(iOS 8.0, *)
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        
        // Process the received push
        
        // Below process is specific to schedule local notification once pushkit payload received
        
        var arrTemp = [AnyHashable: Any]()
        arrTemp = payload.dictionaryPayload
        
        let dict : Dictionary <String, AnyObject> = arrTemp["aps"] as! Dictionary<String, AnyObject>
        
        
        if isUserHasLoggedInWithApp // Check this flag then only proceed
        {
            
            if UIApplication.shared.applicationState == UIApplicationState.background || UIApplication.shared.applicationState == UIApplicationState.inactive
            {
                
                if checkForIncomingCall // Check this flag to know incoming call or something else
                {
                    
                    var strTitle : String = dict["alertTitle"] as? String ?? ""
                    let strBody : String = dict["alertBody"] as? String ?? ""
                    strTitle = strTitle + "\n" + strBody
                    
                    let notificationIncomingCall = UILocalNotification()
                    
                    notificationIncomingCall.fireDate = Date(timeIntervalSinceNow: 1)
                    notificationIncomingCall.alertBody =  strTitle
                    notificationIncomingCall.alertAction = "Open"
                    notificationIncomingCall.soundName = "SoundFile.mp3"
                    notificationIncomingCall.category = dict["category"] as? String ?? ""

                    //"As per payload you receive"
                    notificationIncomingCall.userInfo = ["key1": "Value1"  ,"key2": "Value2" ]

                    
                    UIApplication.shared.scheduleLocalNotification(notificationIncomingCall)
                    
                }
                else
                {
                    //  something else
                }
                
            }
        }
        
        
    }
    
    //MARK: - Local Notification Methods
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification){
        
        // Your interactive local notification events will be called at this place
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

