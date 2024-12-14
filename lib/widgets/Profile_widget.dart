import 'dart:async';

import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:flutter/material.dart';

class ListingInfoBar extends StatelessWidget {
  final int viewCount;
  final int interestCount;

  const ListingInfoBar({
    Key? key,
    required this.viewCount,
    required this.interestCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildInfoItem(
              Icons.remove_red_eye_outlined, Colors.green, '$viewCount Views'),
          SizedBox(width: 12),
          _buildInfoItem(Icons.bookmark, Colors.green[700]!,
              '$interestCount Showed Interest'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, Color color, String text) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(171, 217, 111, 0.2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class Verified extends StatefulWidget {
  final String textWidget;

  const Verified({Key? key, required this.textWidget}) : super(key: key);

  @override
  State<Verified> createState() => _VerifiedState();
}

class _VerifiedState extends State<Verified> {
  @override
  void initState() {
    super.initState();
    // Set a timer to navigate back after 3 seconds
    Timer(const Duration(seconds: 3), () {
      navigateToPage(context, BottomNavBar(index: 3));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          widget.textWidget,
          style: TextStyle(
            fontFamily: 'Maven Pro',
            fontSize: 4.w,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
