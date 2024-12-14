import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class Nointernet extends StatelessWidget {
  const Nointernet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/InternetError.svg'),
          SizedBox(
            height: 15,
          ),
          Text(
            "You are not connected to the internet.",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Maven Pro",
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
