// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/Screens/onboardingScreens/get_started.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/images.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({
    Key? key,
    required this.isLoggedIn,
  }) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                widget.isLoggedIn ? BottomNavBar(index: 0) : GetStarted()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 45.h,
          ),
          Center(child: SvgPicture.asset(AppImages.logo)),
          Spacer(),
          SvgPicture.asset(
            AppImages.building,
            width: 100.w,
          )
        ],
      ),
    );
  }
}
