# PushKit_SilentPushNotification


<a href="https://www.paypal.me/hasya25/1"><img src="https://user-images.githubusercontent.com/23353196/30152617-4567dbc4-93d1-11e7-9b3a-20a9c92c1f50.png" style="max-width:100%;" width="170"></a>

# [ Contact Me!  ](https://www.linkedin.com/in/hasyapanchasara/)

PushKit_SilentPushNotification to receive VOIP call while iOS app is in background or terminated state

You can also use pushkit silent push notification for other use like updating local database without opening app etc, you have keep your app in special category and take approvals from Apple.

- Swift language
- Objective C 
- Pushkit
- VOIP integration
- Handle VOIP based calls in background or terminate state
- Local notification to schedule once pushkit payload receive
- Integrate Pushkit in iOS App
- Video call integration in iOS App


# Pushkit integration
```
import UIKit
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,PKPushRegistryDelegate {

    var window: UIWindow?

    var isUserHasLoggedInWithApp: Bool = true
    var checkForIncomingCall: Bool = true
    var userIsHolding: Bool = true

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


        if #available(iOS 8.0, *){


            let viewAccept = UIMutableUserNotificationAction()
            viewAccept.identifier = "VIEW_ACCEPT"
            viewAccept.title = "Accept"
            viewAccept.activationMode = .Foreground
            viewAccept.destructive = false
            viewAccept.authenticationRequired =  false

            let viewDecline = UIMutableUserNotificationAction()
            viewDecline.identifier = "VIEW_DECLINE"
            viewDecline.title = "Decline"
            viewDecline.activationMode = .Background
            viewDecline.destructive = true
            viewDecline.authenticationRequired = false

            let INCOMINGCALL_CATEGORY = UIMutableUserNotificationCategory()
            INCOMINGCALL_CATEGORY.identifier = "INCOMINGCALL_CATEGORY"
            INCOMINGCALL_CATEGORY.setActions([viewAccept,viewDecline], forContext: .Default)

            if application.respondsToSelector("isRegisteredForRemoteNotifications")
            {
                let categories = NSSet(array: [INCOMINGCALL_CATEGORY])
                let types:UIUserNotificationType = ([.Alert, .Sound, .Badge])

                let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as? Set<UIUserNotificationCategory>)

                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }

        }
        else{
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }


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

    //MARK: - Local Notification Methods

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification){

        // Your interactive local notification events will be called at this place

    }


}

```

# Create certificates from developer account

![1](https://cloud.githubusercontent.com/assets/23353196/22063145/4997aeb6-dda3-11e6-9eee-5bab741840d3.png)

# Before XCode 9

![2](https://cloud.githubusercontent.com/assets/23353196/22063152/4d4d79be-dda3-11e6-8081-1985fe326f44.png)

# With XCode 9+

Open "Info.Plist" file as "Source Code" and add below "UIBackgroundModes" modes

```
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>voip</string>
    <string>fetch</string>
    <string>remote-notification</string>
</array>

```


# Use this sendSilenPush.php file
```
<?php

// Put your device token here (without spaces):


$deviceToken = '1234567890123456789';
//


// Put your private key's passphrase here:
$passphrase = 'ProjectName';

// Put your alert message here:
$message = 'My first silent push notification!';



$ctx = stream_context_create();
stream_context_set_option($ctx, 'ssl', 'local_cert', 'PemFileName.pem');
stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

// Open a connection to the APNS server
$fp = stream_socket_client(
//  'ssl://gateway.push.apple.com:2195', $err,
'ssl://gateway.sandbox.push.apple.com:2195', $err,
$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

if (!$fp)
exit("Failed to connect: $err $errstr" . PHP_EOL);

echo 'Connected to APNS' . PHP_EOL;

// Create the payload body

$body['aps'] = array(
'content-available'=> 1,
'alert' => $message,
'sound' => 'default',
'badge' => 0,
);



// Encode the payload as JSON

$payload = json_encode($body);

// Build the binary notification
$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

// Send it to the server
$result = fwrite($fp, $msg, strlen($msg));

if (!$result)
echo 'Message not delivered' . PHP_EOL;
else
echo 'Message successfully delivered' . PHP_EOL;

// Close the connection to the server
fclose($fp);
```

# Use below commands to create pem file and use it in above code

```
$ openssl x509 -in aps_development.cer -inform der -out PushCert.pem

// Convert .p12 to .pem. Enter your pass pharse which is the same pwd that you have given while creating the .p12 certificate. PEM pass phrase also same as .p12 cert.  
$ openssl pkcs12 -nocerts -out PushKey1.pem -in pushkey.p12

Enter Import Password:

MAC verified OK

Enter PEM pass phrase:

Verifying - Enter PEM pass phrase:

// To remove passpharse for the key to access globally. This only solved my stream_socket_client() & certificate capath warnings.
$ openssl rsa -in PushKey1.pem -out PushKey1_Rmv.pem

Enter pass phrase for PushChatKey1.pem:

writing RSA key

// To join the two .pem file into one file:
$ cat PushCert.pem PushKey1_Rmv.pem > ApnsDev.pem
```

# Debug pushkit notification in terminated state
```
- Put debug pointer on delegate methods
- Go to edit scheme
- Select run option then Launch -> Wait for executable to be launched
- Send push kit payload from back end
- Once you get payload on device
- it will automatically invoke and debug pointer will invoke at delegate methods.
```

![screen shot 2017-03-03 at 3 47 08 pm](https://cloud.githubusercontent.com/assets/23353196/24032539/9015a508-0b0e-11e7-86cf-5cec7ddbeea4.png)

# Life cycle of app - when app is in terminated and push kit payload comes

- First of all
```
    didFinishLaunchingWithOptions // will invoke
```
- Then 
```
    didReceiveIncomingPushWithPayload // payload method gets invoke
```
- Then if you have local notification
```
    didReceiveLocalNotification  // receive local notification
```
- Then 
```    
    handleActionWithIdentifier // handler method if you have action buttons ( local )
```
- Then if you have remote notification
```
    didReceiveRemoteNotification // receive remote notification
```
- Then 
```
    handleActionWithIdentifier // handler method if you have action buttons ( remote ) 
```




<a href="https://www.paypal.me/hasya25/1"><img src="https://user-images.githubusercontent.com/23353196/30152617-4567dbc4-93d1-11e7-9b3a-20a9c92c1f50.png" style="max-width:100%;" width="170"></a>


# [ Contact Me!  ](https://www.linkedin.com/in/hasyapanchasara/)
