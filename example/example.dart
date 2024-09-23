import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:flutter/material.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SEND OTP SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _reqId = '';
  bool _showOtpField = false;
  bool _canResendOtp = false;
  final String widgetId = "Enter your widgetID here";
  final String tokenAuth = "Enter your auth token here";
  @override
  void initState() {
    super.initState();
    OTPWidget.initializeWidget(widgetId, tokenAuth);
    print('Widget initialization...');
  }

  Future<void> sendOTP() async {
    final String identifier = _identifierController.text;
    final payload = {
      'identifier': identifier,
    };

    final response = await OTPWidget.sendOTP(payload);
    print('Response---${response}');
    if (response != null && response['type'] == 'success') {
      if (response.containsKey('access-token')) {
        _showToast(context, 'Number Verified!!!');
      } else {
        setState(() {
          _reqId = response['message'];
          _showOtpField = true;
          _canResendOtp = true;
        });
        print("OTP sent successfully.");
        _showToast(context, 'OTP Sent!!');
      }
    } else {
      _showToast(context, 'Sending OTP failed');
      print("Failed to send OTP: ${response}");
    }
  }

  Future<void> verifyOTP() async {
    final String otp = _otpController.text;
    final payload = {
      'reqId': _reqId,
      'otp': otp,
    };
    final response = await OTPWidget.verifyOTP(payload);
    print('response of verification-----${response}');

    if (response != null && response['type'] == 'success') {
      setState(() {
        _identifierController.clear();
        _otpController.clear();
        _showOtpField = false;
        _reqId = '';
        _canResendOtp = false;
      });
      print("OTP verified successfully.");
      _showToast(context, 'OTP verified!!');
    } else {
      _showToast(context, 'OTP veriffication failed!!');
      print("Failed to verify OTP: ${response}");
    }
  }

  Future<void> retryOTP() async {
    final payload = {'reqId': _reqId};
    final response = await OTPWidget.retryOTP(payload);
    print('response of retry-----${response}');

    if (response != null && response['type'] == 'success') {
      _showToast(context, 'Resend OTP');
      print("OTP resend successfully.");
    } else {
      _showToast(context, 'OTP resend failed');
      print("Failed to retry OTP: ${response}");
    }
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

  void resetApp() {
    setState(() {
      _identifierController.clear();
      _otpController.clear();
      _showOtpField = false;
      _reqId = '';
      _canResendOtp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEND OTP SDK'),
        actions: <Widget>[
          // Add your buttons here
          ElevatedButton(
            onPressed: resetApp,
            child: Text('Reset'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _identifierController,
              decoration: InputDecoration(
                labelText: 'Mobile Number or Email',
              ),
            ),
            if (_showOtpField)
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendOTP,
              child: Text('Send OTP'),
            ),
            if (_showOtpField)
              ElevatedButton(
                onPressed: verifyOTP,
                child: Text('Verify OTP'),
              ),
            if (_canResendOtp)
              ElevatedButton(
                onPressed: retryOTP,
                child: Text('Retry OTP'),
              ),
          ],
        ),
      ),
    );
  }
}
