import 'package:bhumii/Models/Detail_Property_model.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/launchMaps.dart';
import 'package:bhumii/utils/whatsappLaunch.dart';
import 'package:bhumii/widgets/Property_list_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:svg_flutter/svg.dart';

class PropertyDetailScreen extends StatefulWidget {
  final int listingId;
  // final void Function(int propertyId, bool isSaved) onBookmarkToggled;

  PropertyDetailScreen({
    Key? key,
    required this.listingId,
    // required this.onBookmarkToggled,
  }) : super(key: key);

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

void _startDownload(BuildContext context, String url) {
  final _flutterDownload = MediaDownload();
  _flutterDownload.downloadMedia(context, url);
}

void _shareContent() {
  final content =
      'Check out this awesome content!'; // Replace with your content

  Share.share(content);
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool _isExpandedInvestmentThesis = false;
  bool _isExpandedLocation = false;
  bool _isExpandedSiteDetails = false;
  bool _isExpandedPrice = false;
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  final ApiService _apiService = ApiService();
  late Future<Listing> _listingFuture;

  @override
  void initState() {
    super.initState();
    _listingFuture = _apiService.fetchListing(widget.listingId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> toggleBookmark(int propertyId) async {
    await ApiService.toggleBookmark(propertyId);

    // setState(() {
    //   // Update the listing's isSaved status
    //   widget.listings.firstWhere((l) => l.id == propertyId).attributes.isSaved =
    //       !widget.listings
    //           .firstWhere((l) => l.id == propertyId)
    //           .attributes
    //           .isSaved;
    //   widget.onBookmarkToggled(
    //       propertyId,
    //      listing.attributes
    //           .firstWhere((l) => l.id == propertyId)
    //           .attributes
    //           .isSaved);
    // });
  }

  GoogleMapController? mapController;

  // Your provided latitude and longitude

  // Camera position using the default location

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                navigateBack(context);
              },
              child: const Icon(Icons.arrow_back_ios))),
      body: FutureBuilder<Listing>(
        future: _listingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final listing = snapshot.data!;
            LatLng defaultLocation = LatLng(
                listing.attributes?.location?.firstOrNull?.latitude ?? 0.0,
                listing.attributes?.location?.firstOrNull?.longitude ?? 0.0);

            CameraPosition defaultCameraLocation = CameraPosition(
              target: defaultLocation,
              zoom: 13.4746,
            );

            var adminInputs = listing.attributes?.adminInputs;
            double percentage = 0;
            String formattedPercentage = '0';
            int remainingPercentage = 100;

            if (adminInputs != null && adminInputs is AdminInputs) {
              var fundedValue = adminInputs.fundedValue;
              var assetValue = adminInputs.assetValue;

              if (fundedValue is num && assetValue is num && assetValue != 0) {
                percentage = (fundedValue / assetValue) * 100;
                formattedPercentage = percentage.toStringAsFixed(0);
                remainingPercentage = 100 - percentage.toInt();
              }
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: listing.attributes!.propertyDetails!
                                    .propertyPhotos!.isNotEmpty
                                ? PageView.builder(
                                    controller: _pageController,
                                    itemCount: listing
                                        .attributes!
                                        .propertyDetails!
                                        .propertyPhotos!
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        listing.attributes!.propertyDetails!
                                            .propertyPhotos![index],
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : SvgPicture.asset("assets/images/NoPic.svg"),
                          ),
                        ),
                        if (listing.attributes!.propertyDetails!.propertyPhotos!
                            .isNotEmpty)
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: listing.attributes!.propertyDetails!
                                    .propertyPhotos!.length,
                                effect: WormEffect(
                                  dotColor: Colors.grey,
                                  activeDotColor: Colors.white,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  spacing: 8,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          width: 35,
                          child: Image.network(
                            listing.attributes!.userDetails!.compnayLogoUrl
                                .toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          listing.attributes?.userDetails?.companyName ?? '',
                          style: TextStyle(
                              fontFamily: 'Maven Pro',
                              fontSize: 4.w,
                              color: AppColors.lightTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        GreenGradientContainer(
                          rating: listing.attributes!.propertyAverageRating
                              .toString(),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            print("property id is ${widget.listingId}");
                            toggleBookmark(widget.listingId);
                          },
                          child: Icon((listing.attributes?.isSaved == true)
                              ? Icons.bookmark
                              : Icons.bookmark_border),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        InkWell(
                          onTap: () {
                            _shareContent();
                          },
                          child: Icon(
                            Icons.share_outlined,
                            color: AppColors.lightTextColor,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          listing.attributes?.userDetails?.companyName ?? '',
                          style: TextStyle(
                              fontFamily: 'Maven Pro',
                              fontSize: 6.5.w,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        Text(
                          '${listing.attributes?.propertyReviewCount ?? 0} Reviews',
                          style: TextStyle(
                              fontFamily: 'Maven Pro',
                              fontSize: 3.w,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.8.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: AppColors.lightTextColor,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          listing.attributes!.location![0].address.toString(),
                          style: TextStyle(
                            fontFamily: 'Maven Pro',
                            fontSize: 3.2.w,
                            color: AppColors.lightTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.8.h,
                    ),
                    InkWell(
                      onTap: () {
                        launchDirections(
                            listing.attributes?.location?[0].latitude,
                            listing.attributes?.location?[0].longitude);
                      },
                      child: Text(
                        'View on map',
                        style: TextStyle(
                          fontFamily: 'Maven Pro',
                          fontSize: 3.2.w,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Minimum Investment',
                      style: TextStyle(
                        fontFamily: 'Maven Pro',
                        fontSize: 3.2.w,
                        color: AppColors.blackColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹ ${listing.attributes?.adminInputs?.fundedValue ?? 0}',
                      style: TextStyle(
                        fontFamily: 'Maven Pro',
                        fontSize: 6.w,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200]!,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Target IRR',
                                  style: TextStyle(
                                      color: AppColors.lightTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 3.5.w),
                                ),
                                Text(
                                  '${listing.attributes?.adminInputs?.targetIrr?.toString() ?? ''}%',
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 5.w),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Yield',
                                  style: TextStyle(
                                      color: AppColors.lightTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 3.5.w),
                                ),
                                Text(
                                  '${listing.attributes?.adminInputs?.yield?.toString() ?? ''}%',
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 5.w),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Asset Value',
                                  style: TextStyle(
                                      color: AppColors.lightTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 3.5.w),
                                ),
                                Text(
                                  '₹${listing.attributes?.adminInputs?.assetValue?.toString() ?? ''} Cr',
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Maven Pro',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹ ${listing.attributes?.adminInputs?.fundedValue?.toString() ?? ''} Cr / ₹ ${listing.attributes?.adminInputs?.assetValue?.toString() ?? ''} Cr',
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontFamily: 'Maven Pro',
                              fontSize: 5.w,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${formattedPercentage}%',
                          style: TextStyle(
                              color: AppColors.green,
                              fontFamily: 'Maven Pro',
                              fontSize: 5.w,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 5,
                      backgroundColor: Colors.grey[250],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 90, 160, 93)),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(
                          width: 1.h, // Adjusted the width for better spacing
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Only $remainingPercentage% ",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Maven Pro',
                                  fontSize: 5.w,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "share remaining",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Maven Pro',
                                  fontSize: 3.3.w,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'OVERVIEW',
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Maven Pro',
                          fontSize: 5.w,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      listing.attributes?.siteDetails?.siteDescription ?? '',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Maven Pro',
                          fontSize: 5.w,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Text(
                      'PUBLISHER DETAILS',
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Maven Pro',
                          fontSize: 5.w,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/demoUser.png',
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              listing.attributes?.userDetails?.userName ?? '',
                              style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: 'Maven Pro',
                                  fontSize: 4.w,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Text(
                                  listing.attributes!.userAverageRating
                                      .toString(),
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 3.8.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                RatingWidget(
                                    rating: listing
                                        .attributes!.userAverageRating!
                                        .toInt(),
                                    totalStars: 5)
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  listing.attributes!.userReviewCount
                                      .toString(),
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 4.w,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  ' Properties Listed',
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 4.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Container(
                                  height: 2.h,
                                  width: 2,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  '${listing.attributes?.userReviewCount ?? 0} Reviews',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontFamily: 'Maven Pro',
                                      fontSize: 4.w,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Card(
                      color: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                        side: BorderSide(
                          color: Colors.grey[400]!, // Border color
                          width: 0.2, // Border width
                        ),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          side: BorderSide(
                            color: AppColors.primaryColor, // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        backgroundColor: AppColors.whiteColor,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Color.fromARGB(255, 215, 222, 239),
                          child: Icon(Icons.article_outlined, size: 20),
                        ),
                        title: Text(
                          'INVESTMENT THESIS',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Maven Pro',
                              fontSize: 4.2.w,
                              fontWeight: FontWeight.w500),
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _isExpandedInvestmentThesis = expanded;
                          });
                        },
                        children: _isExpandedInvestmentThesis
                            ? [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: List.generate(
                                            listing
                                                .attributes!
                                                .investmentDetails!
                                                .investmentThesis!
                                                .length,
                                            (index) => InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: selectedIndex == index
                                                      ? Colors.white
                                                      : Colors.grey.shade200,
                                                  border: Border.all(
                                                    color: selectedIndex ==
                                                            index
                                                        ? AppColors.primaryColor
                                                        : Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                                child: Text(
                                                  listing
                                                          .attributes
                                                          ?.investmentDetails
                                                          ?.investmentThesis?[
                                                              index]
                                                          .header ??
                                                      'No Header',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: selectedIndex ==
                                                            index
                                                        ? AppColors.primaryColor
                                                        : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          listing
                                                  .attributes
                                                  ?.investmentDetails
                                                  ?.investmentThesis?[
                                                      selectedIndex]
                                                  .description ??
                                              'No Description',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            : [],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Card(
                      color: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                        side: BorderSide(
                          color: Colors.grey[400]!, // Border color
                          width: 0.2, // Border width
                        ),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          side: BorderSide(
                            color: AppColors.primaryColor, // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        backgroundColor: AppColors.whiteColor,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Color.fromARGB(255, 215, 222, 239),
                          child: Icon(Icons.map_outlined, size: 20),
                        ),
                        title: Text(
                          'LOCATION',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Maven Pro',
                              fontSize: 4.2.w,
                              fontWeight: FontWeight.w500),
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _isExpandedLocation = expanded;
                          });
                        },
                        children: _isExpandedLocation
                            ? [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listing.attributes!.location![0].address
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Maven Pro',
                                          fontSize: 3.8.w,
                                          color: AppColors.lightTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 0.4.h,
                                      ),
                                      // Text(
                                      //   listing.attributes.location[0].address,
                                      //   style: TextStyle(
                                      //     fontFamily: 'Maven Pro',
                                      //     fontSize: 3.8.w,
                                      //     color: AppColors.lightTextColor,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 0.8.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          launchDirections(
                                              listing.attributes?.location?[0]
                                                  .latitude,
                                              listing.attributes?.location?[0]
                                                  .longitude);
                                        },
                                        child: Text(
                                          'View on map',
                                          style: TextStyle(
                                            fontFamily: 'Maven Pro',
                                            fontSize: 3.2.w,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        height: 300,
                                        width: double.infinity,
                                        child: GoogleMap(
                                          onMapCreated: _onMapCreated,
                                          initialCameraPosition:
                                              defaultCameraLocation,
                                          markers: {
                                            Marker(
                                              markerId:
                                                  MarkerId('defaultLocation'),
                                              position: defaultLocation,
                                            ),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            : [],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Card(
                      color: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                        side: BorderSide(
                          color: Colors.grey[400]!, // Border color
                          width: 0.2, // Border width
                        ),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          side: BorderSide(
                            color: AppColors.primaryColor, // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        backgroundColor: AppColors.whiteColor,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Color.fromARGB(255, 215, 222, 239),
                          child: Icon(Icons.grid_view_outlined, size: 20),
                        ),
                        title: Text(
                          'SITE DETAILS',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Maven Pro',
                              fontSize: 4.2.w,
                              fontWeight: FontWeight.w500),
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _isExpandedSiteDetails = expanded;
                          });
                        },
                        children: _isExpandedSiteDetails
                            ? [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 0.4.h,
                                      ),
                                      Text(
                                        listing.attributes!.siteDetails!
                                            .siteDescription
                                            .toString(),
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontFamily: 'Maven Pro',
                                            fontSize: 4.w,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        '${listing.attributes?.siteDetails?.siteTotalArea} sqrt',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontFamily: 'Maven Pro',
                                            fontSize: 4.5.w,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 0.6.h,
                                      ),
                                      Text(
                                        'Total Opportunity Space',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontFamily: 'Maven Pro',
                                            fontSize: 4.w,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Image.network(listing.attributes!
                                          .siteDetails!.siteBlueprintUrl
                                          .toString())
                                    ],
                                  ),
                                ),
                              ]
                            : [],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Card(
                      color: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                        side: BorderSide(
                          color: Colors.grey[400]!, // Border color
                          width: 0.2, // Border width
                        ),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          side: BorderSide(
                            color: AppColors.primaryColor, // Border color
                            width: 1.5, // Border width
                          ),
                        ),
                        backgroundColor: AppColors.whiteColor,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Color.fromARGB(255, 215, 222, 239),
                          child: Icon(Icons.currency_rupee_outlined, size: 20),
                        ),
                        title: Text(
                          'PRICE',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: 'Maven Pro',
                              fontSize: 4.2.w,
                              fontWeight: FontWeight.w500),
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _isExpandedPrice = expanded;
                          });
                        },
                        children: _isExpandedPrice
                            ? [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   children: [
                                      //     buildCostBarPart(
                                      //         adminInputs?.constructionCost ?? 0,
                                      //         Colors.blue[200]!,
                                      //         "Construction cost"),
                                      //     buildCostBarPart(
                                      //         adminInputs?.standAndRegistration ?? 0,
                                      //         Colors.green[200]!,
                                      //         "Stamp duty and registration"),
                                      //     buildCostBarPart(
                                      //         adminInputs?.acquisitionFee ?? 0,
                                      //         Colors.pink[200]!,
                                      //         "Acquisition Fee"),
                                      //     buildCostBarPart(
                                      //         adminInputs?.approvalAndLegalCharges ??
                                      //             0,
                                      //         Colors.yellow[200]!,
                                      //         "Approval, Legal, etc. charges"),
                                      //   ],
                                      // ),
                                      Text(
                                        'Total Amount: ₹ ${listing.attributes?.pricing?.totalAmount} Cr',
                                        style: TextStyle(
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 2.h),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: listing.attributes?.pricing
                                            ?.amountBreakdown?.length,
                                        itemBuilder: (context, index) {
                                          return CostItemWidget(
                                              expenseType: listing
                                                      .attributes
                                                      ?.pricing
                                                      ?.amountBreakdown?[index]
                                                      .expenseType ??
                                                  '',
                                              cost: listing
                                                      ?.attributes
                                                      ?.pricing
                                                      ?.amountBreakdown?[0]
                                                      ?.cost ??
                                                  0);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ]
                            : [],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    InkWell(
                      onTap: () {
                        _startDownload(
                          context,
                          listing.attributes?.investmentDetails
                                  ?.investmentDeckUrl ??
                              "",
                        );
                      },
                      child: Card(
                        color: AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          side: BorderSide(
                            color: Colors.grey[400]!, // Border color
                            width: 0.2, // Border width
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(12.0), // Rounded corners
                            border: Border.all(
                              width: 0.2,
                              color: AppColors.whiteColor,
                            ), // Border color
                            // Background color
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    Color.fromARGB(255, 215, 222, 239),
                                child: Icon(Icons.monitor_heart_outlined,
                                    size: 20),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'INVESTMENT DECK',
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontFamily: 'Maven Pro',
                                    fontSize: 4.2.w,
                                    fontWeight: FontWeight.w500),
                              ),
                              // SizedBox(height: 5),
                              Spacer(),
                              Icon(Icons.file_download_outlined,
                                  size: 30, color: Colors.grey),
                              SizedBox(
                                width: 2.w,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Text(
                      'RESOURCES',
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Maven Pro',
                          fontSize: 5.w,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DownloadCard(
                          title: 'Investment Memo',
                          fileType: 'PDF',
                          onTap: () => _startDownload(
                            context,
                            listing.attributes?.resources?.investmentMemoUrl ??
                                "",
                          ),
                        ),
                        SizedBox(width: 2.w),
                        DownloadCard(
                          title: 'Financial Calculator',
                          fileType: 'PDF',
                          onTap: () => _startDownload(
                            context,
                            listing.attributes?.resources
                                    ?.financialCalculatorUrl ??
                                "",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomButton(
                          text: 'Know More',
                          textColor: AppColors.primaryColor,
                          backgroundColor: Colors.white,
                          borderColor: AppColors.primaryColor,
                          onTap: () {
                            launchWhatsApp(context);
                          },
                        ),
                        SizedBox(width: 1.w), // Space between buttons
                        CustomButton(
                          text: 'Invest',
                          textColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          onTap: () {
                            launchWhatsApp(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
