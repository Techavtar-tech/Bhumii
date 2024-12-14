import 'dart:convert';

import 'package:bhumii/Models/Property_model.dart';
import 'package:bhumii/Screens/ExceptionScreen/Filter.dart';
import 'package:bhumii/Screens/PropertyScreens/Property_details.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/images.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/sharedPreference.dart';
import 'package:bhumii/utils/whatsappLaunch.dart';
import 'package:bhumii/widgets/Property_list_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String selectedSort = 'Sort';
  String selectedLocation = 'Location';
  String selectedBuilder = 'Builder';
  String selectedCompany = 'Company';
  List<Listing> listings = [];
  bool isLoading = true;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchListings();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchListings({String? location, String? companyName}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.getListings(
        location: location,
        companyName: companyName,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Listing> fetchedListings = (data['data'] as List)
            .map((item) => Listing.fromJson(item))
            .toList();
        print(response.body);
        // Sorting logic remains the same
        switch (selectedSort) {
          case 'IRR (lowest to highest)':
            fetchedListings.sort((a, b) =>
                (a.attributes.adminInputs?.targetIrr ?? 0)
                    .compareTo(b.attributes.adminInputs?.targetIrr ?? 0));
            break;
          case 'IRR (Highest to Lowest)':
            fetchedListings.sort((a, b) =>
                (b.attributes.adminInputs?.targetIrr ?? 0)
                    .compareTo(a.attributes.adminInputs?.targetIrr ?? 0));
            break;
          case 'Asset Value (Highest to Lowest)':
            fetchedListings.sort((a, b) =>
                (b.attributes.adminInputs?.assetValue ?? 0)
                    .compareTo(a.attributes.adminInputs?.assetValue ?? 0));
            break;
          case 'Asset Value (lowest to highest)':
            fetchedListings.sort((a, b) =>
                (a.attributes.adminInputs?.assetValue ?? 0)
                    .compareTo(b.attributes.adminInputs?.assetValue ?? 0));
            break;
        }

        setState(() {
          listings = fetchedListings;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load listings');
      }
    } catch (e) {
      print('Error fetching listings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void clearAllFilters() {
    setState(() {
      selectedSort = 'Sort';
      selectedLocation = 'Location';
      selectedBuilder = 'Builder';
      selectedCompany = 'Company';
    });
    fetchListings();
  }

  Future<void> toggleBookmark(int propertyId) async {
    await ApiService.toggleBookmark(propertyId);

    setState(() {
      // Update the listing's isSaved status
      listings.firstWhere((l) => l.id == propertyId).attributes.isSaved =
          !listings.firstWhere((l) => l.id == propertyId).attributes.isSaved;
    });
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortBottomSheet(
          onSortSelected: (String sort) {
            setState(() {
              selectedSort = sort;
            });
            fetchListings();
          },
          onClearSort: () {
            setState(() {
              selectedSort = 'Sort'; // Reset to default
            });
            fetchListings();
          },
        );
      },
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LocationBottomSheet(
          currentLocation: selectedLocation,
          onLocationSelected: (String? location) {
            setState(() {
              selectedLocation = location ?? 'Location';
            });
            fetchListings(
              location: location,
              companyName:
                  selectedBuilder != 'Builder' ? selectedBuilder : null,
            );
          },
        );
      },
    );
  }

  void _showBuilderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BuilderBottomSheet(
          currentBuilder: selectedBuilder,
          onBuilderSelected: (String? builder) {
            setState(() {
              selectedBuilder = builder ?? 'Builder';
            });
            fetchListings(
              location:
                  selectedLocation != 'Location' ? selectedLocation : null,
              companyName: builder,
            );
          },
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  SystemNavigator.pop(); // This will close the app
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () => AuthService.handleLogout(context),
                  child: Container(
                    height: 4.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Maven Pro',
                          fontSize: 4.w,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 6.h,
                  child: Row(
                    children: [
                      _buildFilterButton(
                        text: selectedSort,
                        onTap: () => _showSortBottomSheet(context),
                        isSelected: selectedSort != 'Sort',
                      ),
                      SizedBox(width: 8),
                      _buildFilterButton2(
                        text: selectedLocation,
                        onTap: () => _showLocationBottomSheet(context),
                      ),
                      SizedBox(width: 8),
                      _buildFilterButton2(
                        text: selectedBuilder,
                        onTap: () => _showBuilderBottomSheet(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : listings.isEmpty
                        ? Filter(onClearFilters: clearAllFilters)
                        : ListView.builder(
                            itemCount: listings.length,
                            itemBuilder: (context, index) {
                              final listing = listings[index];
                              final attributes = listing.attributes;

                              // double percentage = attributes
                              //                 .adminInputs?.fundedValue !=
                              //             null &&
                              //         attributes.adminInputs?.assetValue != null
                              //     ? (attributes.adminInputs!.fundedValue /
                              //             attributes.adminInputs!.assetValue) *
                              //         100
                              //     : 0.0;
                              double percentage = attributes.fundingPercentage;
                              String formattedPercentage =
                                  percentage.toStringAsFixed(0);

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        const BoxShadow(
                                          offset: Offset(0, .1),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: 180,
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                child: attributes
                                                                .propertyDetails!
                                                                .propertyPhotos !=
                                                            null &&
                                                        attributes
                                                            .propertyDetails!
                                                            .propertyPhotos!
                                                            .isNotEmpty
                                                    ? PageView.builder(
                                                        controller:
                                                            _pageController,
                                                        itemCount: attributes
                                                            .propertyDetails!
                                                            .propertyPhotos!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Image.network(
                                                            attributes
                                                                .propertyDetails!
                                                                .propertyPhotos![index],
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      )
                                                    : SvgPicture.asset(
                                                        "assets/images/NoPic.svg"),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColors.blackColor
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 3),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 20,
                                                        color: AppColors
                                                            .whiteColor,
                                                      ),
                                                      Text(
                                                        attributes.location
                                                                .isNotEmpty
                                                            ? attributes
                                                                .location[0]
                                                                .address!
                                                            : 'N/A',
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Maven Pro',
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                              child: attributes.adminInputs
                                                          ?.totallyFunded ==
                                                      true
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .whiteColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 3),
                                                        child: Text(
                                                          'Fully Funded',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Maven Pro',
                                                            color:
                                                                Color.fromRGBO(
                                                                    7,
                                                                    136,
                                                                    255,
                                                                    1),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ),
                                            if (listing
                                                .attributes
                                                .propertyDetails!
                                                .propertyPhotos!
                                                .isNotEmpty)
                                              Positioned(
                                                bottom: 10,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: SmoothPageIndicator(
                                                    controller: _pageController,
                                                    count: attributes
                                                                .propertyDetails!
                                                                .propertyPhotos !=
                                                            null
                                                        ? attributes
                                                            .propertyDetails!
                                                            .propertyPhotos!
                                                            .length
                                                        : 0,
                                                    effect: WormEffect(
                                                      dotColor: Colors.grey,
                                                      activeDotColor:
                                                          Colors.white,
                                                      dotHeight: 8,
                                                      dotWidth: 8,
                                                      spacing: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 35,
                                                    child: Image.network(
                                                      attributes.userDetails
                                                              ?.companyLogoUrl ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.w),
                                                  Text(
                                                    attributes.userDetails
                                                            ?.companyName ??
                                                        '',
                                                    style: TextStyle(
                                                        fontFamily: 'Maven Pro',
                                                        fontSize: 4.w,
                                                        color: AppColors
                                                            .lightTextColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () {
                                                      toggleBookmark(
                                                          listing.id);
                                                    },
                                                    child: Icon(
                                                      attributes.isSaved
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_border,
                                                    ),
                                                  ),
                                                  SizedBox(width: 1.w),
                                                  ShareIconWidget(),
                                                ],
                                              ),
                                              SizedBox(height: 1.h),
                                              Text(
                                                attributes.userDetails
                                                        ?.companyName ??
                                                    "",
                                                style: TextStyle(
                                                    fontFamily: 'Maven Pro',
                                                    fontSize: 5.w,
                                                    color: AppColors.blackColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 1.5.h),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200]!,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            'Target IRR',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .lightTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Maven Pro',
                                                                fontSize:
                                                                    3.5.w),
                                                          ),
                                                          Text(
                                                            ' ${attributes.adminInputs?.targetIrr?.toString() ?? ''}%',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Maven Pro',
                                                                fontSize: 5.w),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            'Yield',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .lightTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Maven Pro',
                                                                fontSize:
                                                                    3.5.w),
                                                          ),
                                                          Text(
                                                            ' ${attributes.adminInputs?.yield?.toString() ?? ''}%',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Maven Pro',
                                                                fontSize: 5.w),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            'Asset Value',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .lightTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Maven Pro',
                                                                fontSize:
                                                                    3.5.w),
                                                          ),
                                                          Text(
                                                            '₹${attributes.adminInputs?.assetValue?.toString() ?? ''} ',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Maven Pro',
                                                                fontSize: 5.w),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '₹ ${attributes.adminInputs?.fundedValue?.toString() ?? ''}  / ₹ ${attributes.adminInputs?.assetValue?.toString() ?? ''} ',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontFamily: 'Maven Pro',
                                                        fontSize: 5.w,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    '${formattedPercentage}%',
                                                    style: TextStyle(
                                                        color: AppColors.green,
                                                        fontFamily: 'Maven Pro',
                                                        fontSize: 5.w,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              LinearProgressIndicator(
                                                value: percentage / 100,
                                                minHeight: 5,
                                                backgroundColor:
                                                    Colors.grey[250],
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color.fromARGB(
                                                            255, 90, 160, 93)),
                                              ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      navigateToPage(
                                                          context,
                                                          PropertyDetailScreen(
                                                            listingId:
                                                                listing.id,
                                                          ));
                                                    },
                                                    child: Container(
                                                      height: 5.5.h,
                                                      width: 43.w,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                          child: Text(
                                                        'View Details',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .primaryColor,
                                                            fontFamily:
                                                                'Maven Pro',
                                                            fontSize: 4.w,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      launchWhatsApp(context);
                                                    },
                                                    child: Container(
                                                      height: 5.5.h,
                                                      width: 43.w,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .primaryColor,
                                                          border: Border.all(
                                                            color: AppColors
                                                                .primaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Center(
                                                          child: Text(
                                                        'Express Interest',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .whiteColor,
                                                            fontFamily:
                                                                'Maven Pro',
                                                            fontSize: 4.w,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              );
                            },
                          ))
          ])),
    );
  }
}

Widget _buildFilterButton2({
  required String text,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: text == 'Location' || text == 'Builder'
            ? Colors.grey[300]!
            : Colors.blue,
      ),
      borderRadius: BorderRadius.circular(4),
      color: text == 'Location' || text == 'Builder'
          ? Colors.white
          : Colors.blue.withOpacity(0.1),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppColors.lightTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: AppColors.lightTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildFilterButton({
  required String text,
  required VoidCallback onTap,
  required bool isSelected,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? Colors.blue : Colors.grey[300]!,
      ),
      borderRadius: BorderRadius.circular(4),
      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppColors.lightTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: AppColors.lightTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    ),
  );
}
