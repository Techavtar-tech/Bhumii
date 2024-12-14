import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/Screens/onboardingScreens/OtpScreen.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/images.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/validator/validator.dart';
import 'package:bhumii/widgets/Sign_In_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _selectedCountryCode = '+91';
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        "611308201833-v4hg5tsq4u1nee4mdrgjkpq96f15smeo.apps.googleusercontent.com",
    scopes: [
      'email',
      'profile',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    setState(() {
      _isPhoneValid =
          Validators.validatePhoneNumber(_phoneController.text) == null;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_isPhoneValid) {
      debugPrint("workingggg");
      try {
        var response = await ApiService.signInOtp(
            _selectedCountryCode + _phoneController.text);
        // int id = response['data']['id'];
        String otpLess_request_id = response['data']['otpLess_request_id'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully'),
            duration: Duration(seconds: 2), // Adjust as needed
          ),
        );
        navigateToPage(
          context,
          OtpScreen(
            phoneNumber: _phoneController.text,
            otpLess_request_id: otpLess_request_id,
          ),
        );
      } catch (e) {
        print('Failed to send OTP: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
              'Sign-in',
              style: TextStyle(
                  fontSize: 7.5.w,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Maven Pro'),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountryCode,
                    decoration: const InputDecoration(
                      labelText: 'Country Code',
                    ),
                    items: const [
                      DropdownMenuItem(value: '+91', child: Text('+91')),
                      DropdownMenuItem(value: '+1', child: Text('+1')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryCode = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: Validators.validatePhoneNumber,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            InkWell(
              onTap: _isPhoneValid ? _sendOTP : null,
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                    color: _isPhoneValid
                        ? AppColors.primaryColor
                        : AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(3.w)),
                child: Center(
                  child: Text(
                    "Send OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Maven Pro',
                        fontSize: 4.w,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            RichText(
              text: TextSpan(
                text: 'By clicking, I accept ',
                style: TextStyle(
                    fontSize: 3.w,
                    fontFamily: 'Maven Pro',
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' & '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Or Sign-in with',
                style: TextStyle(
                  fontSize: 4.8.w,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CustomButton(
              iconAsset: AppImages.googleLogo,
              text: 'Continue with Google',
              onTap: () {
                _googleSignIn.signIn().then((value) async {
                  final GoogleSignInAuthentication googleAuth =
                      await value!.authentication;
                  final String accessToken = googleAuth.accessToken!;

                  // final String idToken = googleAuth.idToken!;
                  ApiService.googleSignInApi(accessToken);

                  // print("This is google access Token   $accessToken \n");
                  // print("This is google id token   $idToken \n");

                  navigateToPage(
                      context,
                      BottomNavBar(
                        index: 0,
                      ));
                });
              },
            ),
            CustomButton(
              iconAsset: AppImages.linkedInLogo,
              text: 'Continue with LinkedIn',
              onTap: () {},
            ),
            CustomButton(
              iconAsset: AppImages.truecaller,
              text: 'One tap login with Truecaller',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
