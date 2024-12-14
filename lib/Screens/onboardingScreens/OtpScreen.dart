import 'dart:async';
import 'dart:convert';

import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/Screens/onboardingScreens/Your_details.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String otpLess_request_id;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.otpLess_request_id,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  bool isOtpComplete = false;
  int resendTime = 60;
  late Timer _timer;
  String otpLess_request_id = '';

  @override
  void initState() {
    super.initState();
    otpLess_request_id = widget.otpLess_request_id;
    print("otpLess_request_id is - $otpLess_request_id");
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (resendTime == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          resendTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    if (isOtpComplete) {
      String enteredOtp = otpController.text;
      int otp = int.parse(enteredOtp);
      try {
        var response = await ApiService.verifyOtp(otp, otpLess_request_id);
        var responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['status']) {
          String token = responseData['data']['token'];
          Globaltoken = token;
          ApiService.updateGlobalToken(token);

          var user = responseData['data']['user'];

          String? firstname = user['first_name'] as String?;
          String? lastname = user['last_name'] as String?;
          int? userId = user['id'] as int?;

          print("First Name - $firstname");
          print("Last Name - $lastname");
          print("id - $userId");

          if (firstname == null || lastname == null) {
            navigateToPage(
              context,
              YourDetails(
                id: userId ?? 0,
              ),
            );
          } else {
            navigateToPage(
              context,
              BottomNavBar(
                index: 0,
              ),
            );
          }
        }
      } catch (e) {
        print('Error verifying OTP: $e');
        // You might want to show an error message to the user here
      }
    }
  }

  Future<void> resendOtp() async {
    try {
      var response = await ApiService.signInOtp('91${widget.phoneNumber}');
      if (response != null && response['status']) {
        setState(() {
          otpLess_request_id = response['data']['otpLess_request_id'];
          resendTime = 60;
          startTimer();
        });
        // Clear existing OTP field
        otpController.clear();
        isOtpComplete = false;
        // Show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP resent successfully')),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP. Please try again.')),
        );
      }
    } catch (e) {
      print('Error resending OTP: $e');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          leading: InkWell(
              onTap: () {
                navigateBack(context);
              },
              child: const Icon(Icons.arrow_back_ios))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(
                  fontSize: 7.5.w,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Maven Pro'),
            ),
            RichText(
              text: TextSpan(
                text: 'OTP was sent to ',
                style: TextStyle(
                    fontSize: 4.w,
                    fontFamily: 'Maven Pro',
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.phoneNumber,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                      text: ' Change',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigateBack(context);
                        }),
                ],
              ),
            ),
            SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: 6,
              controller: otpController,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.disabled,
              animationType: AnimationType.none,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 58,
                fieldWidth: 58,
                activeColor: AppColors.primaryColor,
                selectedColor: AppColors.primaryColor,
                selectedFillColor: AppColors.primaryColor,
                inactiveFillColor: const Color(0xfffafafa),
                inactiveColor: const Color(0xfffafafa),
              ),
              onCompleted: (v) {
                setState(() {
                  isOtpComplete = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  isOtpComplete = value.length == 6;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Resend OTP in $resendTime sec',
                  style: TextStyle(
                      fontSize: 4.w,
                      fontFamily: 'Maven Pro',
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightTextColor),
                ),
                TextButton(
                  onPressed: resendTime == 0 ? resendOtp : null,
                  child: Text('Resend'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isOtpComplete ? verifyOtp : null,
                child: Text(
                  'Verify and Proceed',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isOtpComplete ? AppColors.primaryColor : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
