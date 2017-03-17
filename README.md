# PushKit_SilentPushNotification

PushKit_SilentPushNotification to receive VOIP call while iOS app is in background or terminated state

You can also use pushkit silent push notification for other use like updating local database without opening app etc, you have keep your app in special category and take approvals from Apple.

- Swift language
- Objective C 
- Pushkit
- Handle VOIP based calls in background or terminate state

![1](https://cloud.githubusercontent.com/assets/23353196/22063145/4997aeb6-dda3-11e6-9eee-5bab741840d3.png)

![2](https://cloud.githubusercontent.com/assets/23353196/22063152/4d4d79be-dda3-11e6-8081-1985fe326f44.png)


# - Use this sendSilenPush.php file
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

# - Use below commands to create pem file and use it in above code

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

# - Debug pushkit notification in terminated state
```
Put debug pointer on delegate methods, Go to edit scheme, select run option then Launch -> Wait for executable to be launched. Send push kit payload from back end, once you get payload on device, it will automatically invoke and debug pointer will invoke at delegate methods.
```

![screen shot 2017-03-03 at 3 47 08 pm](https://cloud.githubusercontent.com/assets/23353196/24032539/9015a508-0b0e-11e7-86cf-5cec7ddbeea4.png)

