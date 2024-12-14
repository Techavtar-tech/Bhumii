import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String iconAsset;
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.iconAsset,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey[500]!),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  iconAsset,
                  height: 3.h,
                ),
                SizedBox(width: 3.w),
                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.lightTextColor,
                    fontSize: 3.8.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
