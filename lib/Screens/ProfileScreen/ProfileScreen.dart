import 'dart:io';

import 'package:bhumii/Models/Saved_model.dart';
import 'package:bhumii/Models/User_Listed_model.dart';
import 'package:bhumii/Screens/BottomNavBar.dart';
import 'package:bhumii/Screens/EditPropertyScreen/Edit_user_info.dart';
import 'package:bhumii/Screens/ProfileScreen/ComparisionSheet.dart';
import 'package:bhumii/Screens/ProfileScreen/Edit_Details.dart';
import 'package:bhumii/Screens/PropertyScreens/Property_details.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/images.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/firebase_upload.dart';
import 'package:bhumii/utils/sharedPreference.dart';
import 'package:bhumii/utils/whatsappLaunch.dart';
import 'package:bhumii/widgets/Profile_widget.dart';
import 'package:bhumii/widgets/Property_list_Widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:svg_flutter/svg.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const ProfileScreen({super.key, required this.onFinish});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  File? _image;
  String profile_picture_url = '';
  final ImagePicker _picker = ImagePicker();
  late Future<UserModel> futureUserData;
  late Future<ListingListedResponse> futureListingResponse;

  @override
  void initState() {
    super.initState();
    futureUserData = _apiService.fetchUserData();
    futureListingResponse = _apiService.fetchListingResponse();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload the image to Firebase
      String? downloadURL = await uploadPhoto(_image!, 'profile_pictures');

      if (downloadURL != null) {
        profile_picture_url = downloadURL;
        print('Image uploaded successfully. Download URL: $downloadURL');
        _updateUserDetails();
        // Here you can update the user's profile picture URL in your database
        // For example: updateUserProfilePicture(downloadURL);
      } else {
        print('Failed to upload image.');
      }
    }
  }

  Future<void> _updateUserDetails() async {
    bool success = await ApiService.updateProfilePicture(
        profile_picture_url: profile_picture_url);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo updated successfully!')),
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
        SnackBar(content: Text('Failed to update Photo. Please try again.')),
      );
    }
  }

  void _showComparasionBottomSheet(UserModel user) {
    print("Change button tapped");
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.9,
            child: PropertyComparison(
              user: user,
            )));
  }

  void _showLogoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  _showLogoutConfirmationDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  _showDeleteAccountConfirmationDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the bottom sheet
                AuthService.handleLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Your account has been deleted successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
                AuthService.handleLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SvgPicture.asset(AppImages.bhumii, fit: BoxFit.contain),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: _showLogoutBottomSheet,
          ),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: futureUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var user = snapshot.data!;
            print("Saved property data ");
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(user),
                  _buildShortlistedProperties(user),
                  SizedBox(
                    height: 2.h,
                  ),
                  _buildCompareButton(user),
                  _buildListedProperty(),
                  buildHelpAndSupportButton(context),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data found'),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileSection(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: const Color.fromRGBO(214, 214, 214, 1), width: 2)),
            child: InkWell(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // CircleAvatar(
                  //     backgroundColor: Colors.white,
                  //     backgroundImage:
                  //         _image != null ? FileImage(_image!) : null,
                  //     radius: 50,
                  //     child: _image == null
                  //         ? const Icon(
                  //             Icons.person,
                  //             size: 50,
                  //             color: Color.fromRGBO(214, 214, 214, 1),
                  //           )
                  //         : null),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: user.profilePictureUrl != null &&
                            user.profilePictureUrl!.isNotEmpty
                        ? NetworkImage(user.profilePictureUrl!)
                        : null,
                    radius: 50,
                  ),
                  Positioned(
                      child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.edit_outlined,
                              color: AppColors.whiteColor,
                            ),
                          )))
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${user.firstName ?? 'N/A'} ${user.lastName ?? 'N/A'}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.call,
                size: 20,
                color: Color.fromRGBO(214, 214, 214, 1),
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                '${user.mobileNo}',
                style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(109, 109, 109, 1)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 20,
                color: Color.fromRGBO(214, 214, 214, 1),
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                '${user.email}',
                style: TextStyle(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(109, 109, 109, 1)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              navigateToPage(
                context,
                EditDetails(
                  profile_picture_url: user.profilePictureUrl ?? '',
                  id: user.id,
                  email: user.email,
                  firstName: user.firstName ?? '',
                  lastName: user.lastName ?? '',
                  mobileNo: user.mobileNo,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  'Edit Profile ',
                  style: TextStyle(
                      fontSize: 4.w,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShortlistedProperties(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Text(
                  'SHORTLISTED PROPERTIES',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Maven Pro',
                    fontSize: 5.w,
                  ),
                ),
                Text(
                  ' (${user.savedProperties.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Maven Pro',
                    fontSize: 5.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          user.savedProperties.isEmpty // Check if the list is empty
              ? Container(
                  height: 200,
                  width: double.infinity, // Provide a specific width
                  alignment: Alignment.center, // Center the message if needed
                  child: Text(
                    'No properties shortlisted',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Maven Pro',
                      fontSize: 5.w,
                      color: Colors.grey, // Optional: style for the message
                    ),
                  ),
                )
              : Container(
                  height:
                      200, // Ensure the height is fixed when there are properties
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: user.savedProperties.length,
                    itemBuilder: (context, index) {
                      final savedProperty = user.savedProperties[index];
                      print("Saved property data: $savedProperty");
                      return _buildPropertyCard(savedProperty);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildListedProperty() {
    return FutureBuilder<ListingListedResponse>(
        future: futureListingResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Text(
                        'Your listings',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Maven Pro',
                            fontSize: 5.w),
                      ),
                      Text(
                        ' (${snapshot.data!.data.length.toString()})',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Maven Pro',
                            fontSize: 5.w),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              launchWhatsApp(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      'Join Our Community',
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          // fontFamily: 'Maven Pro',
                                          color: AppColors.whiteColor,
                                          fontSize: 3.w,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Image.asset(
                                      'assets/images/Logo/whatsApp.png',
                                      height: 30,
                                      width: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      final listing = snapshot.data!.data[index];
                      return Container(child: _buildListedCard(listing));
                    })
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildPropertyCard(SavedProperty savedProperty) {
    return InkWell(
      onTap: () {
        navigateToPage(
            context, PropertyDetailScreen(listingId: savedProperty.id));
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 130,
                  width: 200,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: savedProperty.propertyDetails.propertyPhotos != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            savedProperty.propertyDetails.propertyPhotos![0],
                            height: 5,
                            fit: BoxFit.fill,
                          ),
                        )
                      : SvgPicture.asset('assets/images/NoPic.svg', height: 15),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GreenGradientContainer(rating: '5'),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Text(
                  savedProperty.userDetails.companyName,
                  style: TextStyle(
                      fontFamily: 'Maven Pro',
                      fontSize: 4.5.w,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // SizedBox(
            //   height: 1.h,
            // ),
            Row(
              children: [
                savedProperty.userDetails.companyLogoUrl != null
                    ? Container(
                        height: 20,
                        width: 20,
                        child: Image.network(
                            savedProperty.userDetails.companyLogoUrl.toString(),
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover),
                      )
                    : SvgPicture.asset('assets/images/NoPic.svg', height: 15),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  savedProperty.userDetails.companyName,
                  style: TextStyle(
                      fontFamily: 'Maven Pro',
                      fontSize: 4.w,
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListedCard(ListingData listing) {
    double principalAmount =
        listing.attributes.adminInputs!.fundedValue.toDouble();
    double totalAmount = listing.attributes.adminInputs!.assetValue.toDouble();
    double percentage =
        totalAmount > 0 ? (principalAmount / totalAmount) * 100 : 0;
    String formattedPercentage = percentage.toStringAsFixed(0);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            offset: Offset(0, .1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: listing.attributes.propertyDetails.propertyPhotos !=
                              null &&
                          listing.attributes.propertyDetails.propertyPhotos!
                              .isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            listing
                                .attributes.propertyDetails.propertyPhotos![0],
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                SvgPicture.asset('assets/images/NoPic.svg',
                                    fit: BoxFit.fill),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SvgPicture.asset('assets/images/NoPic.svg',
                              fit: BoxFit.fill),
                        ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.blackColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: AppColors.whiteColor,
                          ),
                          Text(
                            listing.attributes.location.isNotEmpty
                                ? (listing.attributes.location[0].address ??
                                    "No data")
                                : "No data",
                            style: const TextStyle(
                              fontFamily: 'Maven Pro',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: listing.attributes.isListed
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border: Border.all(color: Colors.green, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: Text(
                                'Listed',
                                style: TextStyle(
                                  fontFamily: 'Maven Pro',
                                  color: Color.fromRGBO(7, 136, 255, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              border:
                                  Border.all(color: Colors.orange, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: Text(
                                'Under Review',
                                style: TextStyle(
                                  fontFamily: 'Maven Pro',
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )),
              ],
            ),
            ListingInfoBar(
              viewCount: listing.attributes.activeViewCount,
              interestCount: listing.attributes.savedBy.length,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      listing.attributes.userDetails.companyLogoUrl.isNotEmpty
                          ? Container(
                              height: 20,
                              width: 20,
                              child: Image.network(
                                listing.attributes.userDetails.companyLogoUrl,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    SvgPicture.asset('assets/images/NoPic.svg',
                                        height: 2.5.h),
                              ),
                            )
                          : SvgPicture.asset('assets/images/NoPic.svg',
                              height: 2.5.h),
                      SizedBox(width: 2.w),
                      Text(
                        listing.attributes.userDetails.companyName,
                        style: TextStyle(
                          fontFamily: 'Maven Pro',
                          fontSize: 4.w,
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: listing.attributes.isListed,
                        child: TextButton.icon(
                          onPressed: () {
                            navigateToPage(
                                context,
                                EditUserPropertyInfo(
                                  listing: listing,
                                  onFinish: () {
                                    widget.onFinish;
                                  },
                                ));
                          },
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.primaryColor, size: 18),
                          label: const Text(
                            'Edit Listing',
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    listing.attributes.userDetails.companyName,
                    style: TextStyle(
                      fontFamily: 'Maven Pro',
                      fontSize: 5.w,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹ ${principalAmount.toStringAsFixed(2)}  / ₹ ${totalAmount.toStringAsFixed(2)} ',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Maven Pro',
                          fontSize: 4.8.w,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${formattedPercentage}%',
                        style: TextStyle(
                          color: AppColors.green,
                          fontFamily: 'Maven Pro',
                          fontSize: 5.w,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 5,
                    backgroundColor: Colors.grey[250],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 90, 160, 93),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareButton(UserModel user) {
    return InkWell(
        onTap: () {
          _showComparasionBottomSheet(user);
        },
        child: Container(
            child: Image.asset('assets/images/CompareProperties.png')));
  }
}

Widget buildHelpAndSupportButton(BuildContext context) {
  return InkWell(
    onTap: () {
      launchWhatsApp(context);
      print('Help & Support tapped');
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.help_center_outlined,
                      color: AppColors.primaryColor, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Help & Support',
                    style: TextStyle(
                      fontFamily: 'Maven Pro',
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.primaryColor, size: 18),
            ],
          ),
        ),
      ),
    ),
  );
}
