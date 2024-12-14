import 'dart:async';

import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/widgets/Profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTP_popup extends StatefulWidget {
  final String phoneNumber;
  final String otpLess_request_id;

  const OTP_popup({
    Key? key,
    required this.phoneNumber,
    required this.otpLess_request_id,
  }) : super(key: key);

  @override
  _OTP_popupState createState() => _OTP_popupState();
}

class _OTP_popupState extends State<OTP_popup> {
  TextEditingController otpController = TextEditingController();
  bool isOtpComplete = false;
  int resendTime = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
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

  void verifyOtp() async {
    try {
      final enteredOtp = int.parse(otpController.text);
      final response = await ApiService.verifyMobileOTP(
          widget.otpLess_request_id, enteredOtp);

      if (response['status'] == true) {
        navigateBack(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Verified(
              textWidget: 'Mobile Number Updated!',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close_outlined),
                ),
              ],
            ),
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 7.5.w,
                fontWeight: FontWeight.w700,
                fontFamily: 'Maven Pro',
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'OTP was sent to ',
                style: TextStyle(
                  fontSize: 4.w,
                  fontFamily: 'Maven Pro',
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightTextColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.phoneNumber,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                fieldHeight: 50,
                fieldWidth: 50,
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
                    color: AppColors.lightTextColor,
                  ),
                ),
                TextButton(
                  onPressed: resendTime == 0
                      ? () {
                          setState(() {
                            resendTime = 60;
                            startTimer();
                          });
                          // Implement resend logic here
                        }
                      : null,
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
