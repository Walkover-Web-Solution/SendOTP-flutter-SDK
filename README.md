# Send OTP Flutter Sdk!

**The SendOtp SDK makes verifying OTP easy. SDK supports the verification of email and phone numbers via SMS, Calls & Whatsapp.**


## Getting started

Login or create account at MSG91 to use sendOTP services.

**Get your widgetId and authToken:**

After login at MSG91, follow below steps to get your widgetId and authToken:
1. Select OTP option available on dashboard.
2. Create and configure your widget.
3. If you are first time user then generate new token and keep it enable.
4. The widgetId and authToken generated from the above steps will be required for initializing the widget.

**Note:** To ensure that this SDK functions correctly within your mobile application, please enable Mobile Integration while configuring the widget.

## Installation

```shell 
flutter pub add sendotp_flutter_sdk
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:otp_widget/otp_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OTPExample(),
    );
  }
}

class OTPExample extends StatefulWidget {
  @override
  _OTPExampleState createState() => _OTPExampleState();
}

class _OTPExampleState extends State<OTPExample> {
  final String widgetId = '3461******************38';  // Your widgetId
  final String authToken = '125*******************TP1'; // Your authToken

  String phoneNumber = '';
  
  @override
  void initState() {
    super.initState();
    OTPWidget.initializeWidget(widgetId, authToken); // Initialize widget
  }

  // Method to send OTP
  Future<void> handleSendOtp() async {
    final data = {'identifier': '91758XXXXXXX'};
    final response = await OTPWidget.sendOTP(data);
    print(response); // Handle response
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send OTP Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter phone number'),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSendOtp,
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
```


# SDK Methods

We provide methods, which helps you integrate the OTP verification within your own user interface.

`getWidgetProcess` is an optional method, this will receive the widget configuration data.
<br>
<br>

There are three methods `sendOTP`, `retryOTP` and `verifyOTP` for the otp verification process.

You can call these methods as follow:

### `sendOTP`

The sendOTP method is used to send an OTP to an identifier. The identifier can be an email or mobile number (it must contain the country code without +).
<br>
You can call this method on a button press.
<br>
<br>

*NOTE:* If you have enabled the invisible option in a widget configuration and you are trying to verify the mobile number with the mobile network then your number will be verified without OTP and if in any case the invisible verification gets fail in between the process then you will receive the normal OTP on your entered number.

```dart
Future<void> handleSendOtp() async {
  final data = {
    'identifier': '91758XXXXXXX'  // Phone number or email
  };
  final response = await OTPWidget.sendOTP(data);
  print(response);  // Handle response
}
```
**or**
```dart
Future<void> handleSendOtp() async {
  final data = {
    'identifier': 'example@mail.com'  // Phone number or email
  };
  final response = await OTPWidget.sendOTP(data);
  print(response);  // Handle response
}
```

### `retryOTP`

The retryOTP method allows retrying the OTP on desired communication channel.
<br>
retryOTP method takes optional channel code for `'SMS-11'`, `'VOICE-4'`, `'EMAIL-3'`, `'WHATSAPP-12'` for retrying otp.

*Note:* If the widget uses the default configuration, don't pass the channel as argument.

```dart
Future<void> handleRetryOtp() async {
  final data = {
    'reqId': '3463***************43931',  // Request ID
    'retryChannel': 11  // Retry via SMS
  };
  final response = await OTPWidget.retryOTP(data);
  print(response);  // Handle response
}
```

### `verifyOTP`

The verifyOTP method is used to verify an OTP entered by the user.

```dart
Future<void> handleVerifyOtp() async {
  final data = {
    'reqId': '3463***************43931',  // Request ID
    'otp': '****'  // OTP entered by the user
  };
  final response = await OTPWidget.verifyOTP(data);
  print(response);  // Handle response
}
```



<br>
<br>
<br>

## License

```
Copyright 2022 MSG91
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```@