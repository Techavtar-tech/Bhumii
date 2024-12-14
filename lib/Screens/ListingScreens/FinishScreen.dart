import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Finishscreen extends StatelessWidget {
  final VoidCallback onFinish;
  const Finishscreen({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar(index: 0)),
          (route) => false,
        );

        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/finish.png",
                height: 150,
                width: 150,
              ),
              Text(
                "Success!",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: "Maven Pro",
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Your listing has been successfully sent for \n`moderation. We will notify you when done.",
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontFamily: "Maven Pro",
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                                index: 1,
                              )));
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(159, 176, 192, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "List Another Property",
                      style: TextStyle(
                          color: Color.fromRGBO(159, 176, 192, 1),
                          fontFamily: "Maven Pro",
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
