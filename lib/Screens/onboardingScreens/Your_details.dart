import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';

class YourDetails extends StatefulWidget {
  final int id;

  const YourDetails({super.key, required this.id});

  @override
  _YourDetailsState createState() => _YourDetailsState();
}

class _YourDetailsState extends State<YourDetails> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateButtonState);
    _lastNameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_updateButtonState);
    _lastNameController.removeListener(_updateButtonState);
    _emailController.removeListener(_updateButtonState);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateUserDetails() async {
    bool success = await ApiService.updateUserDetails(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details updated successfully!')),
      );
      // Navigate after showing snackbar
      Future.delayed(Duration(seconds: 2), () {
        navigateToPage(
            context,
            BottomNavBar(
              index: 0,
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              navigateBack(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your Details',
                style: TextStyle(
                    fontSize: 7.5.w,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Maven Pro'),
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                      fontSize: 4.5.w, color: AppColors.lightTextColor),
                  floatingLabelStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Maven Pro',
                      fontSize: 5.w,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                      fontSize: 4.5.w, color: AppColors.lightTextColor),
                  floatingLabelStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Maven Pro',
                      fontSize: 5.w,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontSize: 4.5.w, color: AppColors.lightTextColor),
                  floatingLabelStyle: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'Maven Pro',
                      fontSize: 5.w,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              ElevatedButton(
                child: Text(
                  'Finish',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: _isButtonEnabled
                      ? AppColors.primaryColor
                      : AppColors.darkGrey,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isButtonEnabled ? _updateUserDetails : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
