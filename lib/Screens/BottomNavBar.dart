import 'package:bhumii/Screens/ChatScreen/ChatScreen.dart';
import 'package:bhumii/Screens/ListingScreens/ListProperty.dart';
import 'package:bhumii/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:bhumii/Screens/PropertyScreens/Property_list.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/whatsappLaunch.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  BottomNavBar({required this.index});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  List<Widget> _screens = [];

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
    _updateScreens();
  }

  void _updateScreens() {
    _screens = [
      PropertyListScreen(),
      Listproperty(
        onFinish: navigateToListingScreen,
        onBack: navigateToHomeScreen,
      ),
      ChatScreen(),
      ProfileScreen(onFinish: navigateToListingScreen),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      //  the chat icon is at index 2
      launchWhatsApp(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void navigateToListingScreen() {
    print("Attempting to navigate to listing screen");
    setState(() {
      _selectedIndex = 1; // Listing is at index 1
      _updateScreens();
    });
    print("_selectedIndex set to: $_selectedIndex");
  }

  void navigateToProfileScreen() {
    print("tapped profile");
    setState(() {
      _selectedIndex = 3; //  profile is at index 3
    });
  }

  void navigateToHomeScreen() {
    setState(() {
      _selectedIndex = 0; //  ProfileScreen is at index 0
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building BottomNavBar with _selectedIndex: $_selectedIndex");
    return WillPopScope(
      onWillPop: () {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
