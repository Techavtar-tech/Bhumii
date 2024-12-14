import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/widgets/Profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Email_OTP extends StatefulWidget {
  final String email;
  final String otpLess_request_id;

  const Email_OTP({
    Key? key,
    required this.email,
    required this.otpLess_request_id,
  }) : super(key: key);

  @override
  _Email_OTPState createState() => _Email_OTPState();
}

class _Email_OTPState extends State<Email_OTP> {
  TextEditingController otpController = TextEditingController();
  bool isOtpComplete = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void verifyOtp() async {
    try {
      final enteredOtp = int.parse(otpController.text);
      final response = await ApiService.verifyEmailOTPAPI(
          enteredOtp, widget.otpLess_request_id);

      if (response['status'] == true) {
        navigateBack(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Verified(
                textWidget: 'Email ID Updated!',
              )),
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
              'Email Id',
              style: TextStyle(
                fontSize: 7.5.w,
                fontWeight: FontWeight.w700,
                fontFamily: 'Maven Pro',
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Enter Otp',
              style: TextStyle(
                fontSize: 3.w,
                color: const Color.fromRGBO(187, 202, 203, 1),
                fontWeight: FontWeight.w700,
                fontFamily: 'Maven Pro',
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
            SizedBox(height: 5.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isOtpComplete ? verifyOtp : null,
                child: Text(
                  'Verify',
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
