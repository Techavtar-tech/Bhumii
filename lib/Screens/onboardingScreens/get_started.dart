import 'package:bhumii/Screens/onboardingScreens/sign_in.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/images.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 14.h,
          ),
          SvgPicture.asset(AppImages.getstarted),
          SizedBox(
            height: 7.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to",
                style: TextStyle(
                    fontSize: 5.w,
                    fontFamily: 'Maven Pro',
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor),
              ),
              SizedBox(
                width: 2.w,
              ),
              SvgPicture.asset(AppImages.bhumii)
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "One stop for all your \n Real Estate Investments",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Maven Pro',
                fontSize: 7.6.w,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                // navigateToPage(context, BottomNavBar(index:0));
                navigateToPage(context, SignInScreen());
              },
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(3.w)),
                child: Center(
                  child: Text(
                    "Get Started",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Maven Pro',
                        fontSize: 5.w,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }
}
