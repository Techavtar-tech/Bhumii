import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/Screens/ProfileScreen/Email_Otp.dart';
import 'package:bhumii/Screens/ProfileScreen/OTP_pop.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDetails extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final int id;
  final String profile_picture_url;
  final String mobileNo;

  const EditDetails(
      {Key? key,
      required this.firstName,
      required this.id,
      required this.lastName,
      required this.profile_picture_url,
      required this.email,
      required this.mobileNo})
      : super(key: key);

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final TextEditingController _EditFirstnameController =
      TextEditingController();
  final TextEditingController _EditLastnameController = TextEditingController();
  final TextEditingController _EditemailController = TextEditingController();
  final TextEditingController _EditphoneController = TextEditingController();
  final TextEditingController _EditnewPhoneController = TextEditingController();

  String _selectedCountryCode = '+91';
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _EditnewPhoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    setState(() {
      _isPhoneValid = _EditnewPhoneController.text.length == 10;
    });
  }

  void _updatePhoneNumber() {
    setState(() {
      _EditphoneController.text = _EditnewPhoneController.text;
      _EditnewPhoneController.clear();
    });
    navigateBack(context);
  }

  @override
  void dispose() {
    _EditFirstnameController.dispose();
    _EditLastnameController.dispose();
    _EditemailController.dispose();
    _EditphoneController.dispose();
    _EditnewPhoneController.dispose();
    super.dispose();
  }

  void _showChangePhoneBottomSheet(String currentPhoneNumber) {
    print("Change button tapped");
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PhoneNumberChange(
              currentPhoneNumber: currentPhoneNumber,
              selectedCountryCode: _selectedCountryCode,
            ));
  }

  void _showChangeEmailBottomSheet() {
    print("Change button tapped");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: EmailVerifyScreen(EditemailController: _EditemailController),
      ),
    );
  }

  Future<void> _updateUserDetails() async {
    print('firstName: ${_EditFirstnameController.text}');
    print('lastName: ${_EditLastnameController.text}');
    bool success = await ApiService.updateNameDetails(
      firstName: _EditFirstnameController.text,
      lastName: _EditLastnameController.text,

      // profile_picture_url: widget.profile_picture_url
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details updated successfully!')),
      );
      // Navigate after showing snackbar
      Future.delayed(Duration(seconds: 2), () {
        navigateToPage(
            context,
            BottomNavBar(
              index: 3,
            ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update details. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                navigateBack(context);
              },
              child: const Icon(Icons.arrow_back_ios))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your Details',
                style: TextStyle(
                  fontSize: 7.5.w,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Maven Pro',
                ),
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: _EditFirstnameController..text = widget.firstName,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                      fontSize: 4.5.w, color: AppColors.lightTextColor),
                  floatingLabelStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'Maven Pro',
                    fontSize: 5.w,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                enabled: true,
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _EditLastnameController..text = widget.lastName,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                      fontSize: 4.5.w, color: AppColors.lightTextColor),
                  floatingLabelStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'Maven Pro',
                    fontSize: 5.w,
                    fontWeight: FontWeight.w400,
                  ),
                  enabled: true,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.darkGrey.withOpacity(.5),
                    ),
                  ),
                ),
                // padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Maven Pro',
                        fontSize: 3.5.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.mobileNo}', // Displaying the static phone number
                          style: TextStyle(
                            fontSize: 3.5.w,
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showChangePhoneBottomSheet(widget
                              .mobileNo), // Passing the current phone number
                          child: Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 4.w,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Divider(color: AppColors.lightTextColor),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.darkGrey.withOpacity(.5),
                    ),
                  ),
                ),
                // padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email ID',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'Maven Pro',
                        fontSize: 3.5.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.email}', // Displaying the static email
                          style: TextStyle(
                            fontSize: 3.5.w,
                            color: AppColors.darkGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: _showChangeEmailBottomSheet,
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 4.w,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: _updateUserDetails,
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Center(
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Maven Pro',
                        fontSize: 4.w,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({
    super.key,
    required TextEditingController EditemailController,
  }) : _EditemailController = EditemailController;

  final TextEditingController _EditemailController;

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  void _submitEmail() async {
    final email = widget._EditemailController.text;
    final response = await ApiService.updateEmailAPI(email);

    final otp = response['data']['otp'];
    final otpLess_request_id = response['data']['otpLess_request_id'];

    print('Email OTP: $otp');
    // print('ID: $id');

    navigateBack(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Email_OTP(
          otpLess_request_id: otpLess_request_id,
          email: widget._EditemailController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  navigateBack(context);
                },
                child: Icon(Icons.close_outlined),
              ),
            ],
          ),
          Text(
            'Email ID',
            style: TextStyle(
              fontSize: 4.5.w,
              fontFamily: 'Maven Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          TextFormField(
            controller: widget._EditemailController,
            decoration: InputDecoration(
              labelText: 'Email ID',
              labelStyle:
                  TextStyle(fontSize: 4.5.w, color: AppColors.lightTextColor),
              floatingLabelStyle: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'Maven Pro',
                fontSize: 5.w,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () {
              _submitEmail();
            },
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Center(
                child: Text(
                  "Send OTP on Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Maven Pro',
                    fontSize: 4.w,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                  ),
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
                color: AppColors.lightTextColor,
              ),
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
        ],
      ),
    );
  }
}

class PhoneNumberChange extends StatefulWidget {
  final String selectedCountryCode;
  final String currentPhoneNumber;
  const PhoneNumberChange(
      {super.key,
      required this.selectedCountryCode,
      required this.currentPhoneNumber});

  @override
  State<PhoneNumberChange> createState() => _PhoneNumberChangeState();
}

class _PhoneNumberChangeState extends State<PhoneNumberChange> {
  final TextEditingController _EditnewPhoneController = TextEditingController();
  final TextEditingController _EditPhoneController = TextEditingController();
  String _selectedCountryCode = '';

  void _submitMobileNumber() async {
    if (_isPhoneValid) {
      // print(
      //     'Sending OTP to $_selectedCountryCode${_EditnewPhoneController.text}');
      // Navigate to the OTP screen
      final mobileNo = _EditnewPhoneController.text;
      final response = await ApiService.updateMobileAPI(mobileNo);

      final otpLess_request_id = response['data']['otpLess_request_id'];
      final id = response['data']['id'];

      // print('Mobile OTP: $otp');
      print('ID: $id');
      navigateBack(context);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: OTP_popup(
            otpLess_request_id: otpLess_request_id,
            phoneNumber: _EditnewPhoneController.text.toString(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = widget.selectedCountryCode;
  }

  bool _isPhoneValid = false;
  void _validatePhone() {
    setState(() {
      _isPhoneValid = _EditnewPhoneController.text.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                GestureDetector(
                  onTap: () {
                    navigateBack(context);
                  },
                  child: Icon(Icons.close_outlined),
                ),
              ],
            ),
            Text(
              'Change Phone Number',
              style: TextStyle(
                fontSize: 4.5.w,
                fontFamily: 'Maven Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Current Phone Number',
              style: TextStyle(
                fontSize: 3.w,
                fontFamily: 'Maven Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Country Code',
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      isDense: true,
                      isExpanded: true,
                      underline: Container(), // Removes the default underline
                      items: const [
                        DropdownMenuItem(value: '+91', child: Text('+91')),
                        DropdownMenuItem(value: '+1', child: Text('+1')),
                      ],
                      onChanged: null, // This makes the dropdown non-editable
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _EditPhoneController
                      ..text = widget.currentPhoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    enabled: false,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              'New Phone Number',
              style: TextStyle(
                fontSize: 3.w,
                fontFamily: 'Maven Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
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
                    controller: _EditnewPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (value) {
                      _validatePhone();
                    },
                    validator: Validators.validatePhoneNumber,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            GestureDetector(
              onTap: _isPhoneValid ? _submitMobileNumber : null,
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: _isPhoneValid
                      ? AppColors.primaryColor
                      : AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: Center(
                  child: Text(
                    "Send OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Maven Pro',
                      fontSize: 4.w,
                      fontWeight: FontWeight.w700,
                      color: AppColors.whiteColor,
                    ),
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
                  color: AppColors.lightTextColor,
                ),
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
          ],
        ),
      ),
    );
  }
}
