class ListingListedResponse {
  final List<ListingData> data;
  final Map<String, dynamic> meta;

  ListingListedResponse({required this.data, required this.meta});

  factory ListingListedResponse.fromJson(Map<String, dynamic> json) {
    return ListingListedResponse(
      data: (json['data'] as List).map((e) => ListingData.fromJson(e)).toList(),
      meta: json['meta'] ?? {},
    );
  }
}

class ListingData {
  final int id;
  final ListingAttributes attributes;

  ListingData({required this.id, required this.attributes});

  factory ListingData.fromJson(Map<String, dynamic> json) {
    return ListingData(
      id: json['id'],
      attributes: ListingAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class ListingAttributes {
  final bool legalAssistance;
  final bool isListed;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final ListingListedBy listedBy;
  final ListingSiteDetails siteDetails;
  final ListingUserDetails userDetails;
  final ListingResources resources;
  final ListingInvestmentDetails investmentDetails;
  final List<ListingLocation> location;
  final ListingPropertyDetails propertyDetails;
  final ListingAdminInputs? adminInputs;
  final double propertyAverageRating;
  final int propertyReviewCount;
  final double userAverageRating;
  final int userReviewCount;
  final List<SavedBy> savedBy; // New field
  final int activeViewCount; // New field

  ListingAttributes({
    required this.legalAssistance,
    required this.isListed,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.listedBy,
    required this.siteDetails,
    required this.userDetails,
    required this.resources,
    required this.investmentDetails,
    required this.location,
    required this.propertyDetails,
    this.adminInputs,
    required this.propertyAverageRating,
    required this.propertyReviewCount,
    required this.userAverageRating,
    required this.userReviewCount,
    required this.savedBy,
    required this.activeViewCount,
  });

  factory ListingAttributes.fromJson(Map<String, dynamic> json) {
    return ListingAttributes(
      legalAssistance: json['legal_assistance'] ?? false,
      isListed: json['is_listed'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      listedBy: json['listed_by'] != null && json['listed_by']['data'] != null
          ? ListingListedBy.fromJson(json['listed_by']['data'])
          : ListingListedBy(
              id: 0, attributes: ListingListedByAttributes(noOfListings: 0)),
      siteDetails: json['site_details'] != null
          ? ListingSiteDetails.fromJson(json['site_details'])
          : ListingSiteDetails(
              id: 0,
              siteDescription: '',
              siteTotalArea: 0,
              siteBlueprintUrl: ''),
      userDetails: json['user_details'] != null
          ? ListingUserDetails.fromJson(json['user_details'])
          : ListingUserDetails(
              id: 0,
              userName: '',
              companyName: '',
              countryCode: '',
              phoneNumber: '',
              userCity: '',
              userAddress: '',
              companyLogoUrl: '',
              previousWorkDetailsUrl: '',
            ),
      resources: json['Resources'] != null
          ? ListingResources.fromJson(json['Resources'])
          : ListingResources(
              id: 0, investmentMemoUrl: '', financialCalculatorUrl: ''),
      investmentDetails: json['investment_details'] != null
          ? ListingInvestmentDetails.fromJson(json['investment_details'])
          : ListingInvestmentDetails(
              id: 0,
              currentFundingDetails: '',
              investmentDeckUrl: '',
              financialPlanUrl: ''),
      location: json['Location'] != null && json['Location'] is List
          ? (json['Location'] as List)
              .map((e) => ListingLocation.fromJson(e))
              .toList()
          : [],
      propertyDetails: json['property_details'] != null
          ? ListingPropertyDetails.fromJson(json['property_details'])
          : ListingPropertyDetails(
              id: 0, propertyOverview: '', propertyPhotos: null),
      adminInputs: ListingAdminInputs.fromJson(json['Admin_inputs'] ?? {}),

      // adminInputs: json['Admin_inputs'] != null
      //     ? ListingAdminInputs.fromJson(json['Admin_inputs'])
      //     : null,
      propertyAverageRating: json['propertyAverageRating']?.toDouble() ?? 0.0,
      propertyReviewCount: json['propertyReviewCount'] ?? 0,
      userAverageRating: json['userAverageRating']?.toDouble() ?? 0.0,
      userReviewCount: json['userReviewCount'] ?? 0,
      savedBy: json['saved_by'] != null && json['saved_by']['data'] is List
          ? (json['saved_by']['data'] as List)
              .map((e) => SavedBy.fromJson(e))
              .toList()
          : [], // New field with null check
      activeViewCount: json['activeViewCount'] ?? 0, // New field
    );
  }
}

class ListingListedBy {
  final int id;
  final ListingListedByAttributes attributes;

  ListingListedBy({required this.id, required this.attributes});

  factory ListingListedBy.fromJson(Map<String, dynamic> json) {
    return ListingListedBy(
      id: json['id'] ?? 0,
      attributes: ListingListedByAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class ListingListedByAttributes {
  final String? email;
  final String? mobileNo;
  final int noOfListings;

  ListingListedByAttributes({
    this.email,
    this.mobileNo,
    required this.noOfListings,
  });

  factory ListingListedByAttributes.fromJson(Map<String, dynamic> json) {
    return ListingListedByAttributes(
      email: json['email'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      noOfListings: json['no_of_listings'] ?? 0,
    );
  }
}

class ListingSiteDetails {
  final int id;
  final String siteDescription;
  final int siteTotalArea;
  final String siteBlueprintUrl;

  ListingSiteDetails({
    required this.id,
    required this.siteDescription,
    required this.siteTotalArea,
    required this.siteBlueprintUrl,
  });

  factory ListingSiteDetails.fromJson(Map<String, dynamic> json) {
    return ListingSiteDetails(
      id: json['id'] ?? 0,
      siteDescription: json['site_description'] ?? '',
      siteTotalArea: json['site_total_area'] ?? 0,
      siteBlueprintUrl: json['site_blueprint_url'] ?? '',
    );
  }
}

class ListingUserDetails {
  final int id;
  final String userName;
  final String companyName;
  final String countryCode;
  final String phoneNumber;
  final String userCity;
  final String userAddress;
  final String companyLogoUrl;
  final String previousWorkDetailsUrl;

  ListingUserDetails({
    required this.id,
    required this.userName,
    required this.companyName,
    required this.countryCode,
    required this.phoneNumber,
    required this.userCity,
    required this.userAddress,
    required this.companyLogoUrl,
    required this.previousWorkDetailsUrl,
  });

  factory ListingUserDetails.fromJson(Map<String, dynamic> json) {
    return ListingUserDetails(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      companyName: json['company_name'] ?? '',
      countryCode: json['country_code'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userCity: json['user_city'] ?? '',
      userAddress: json['user_address'] ?? '',
      companyLogoUrl: json['compnay_logo_url'] ?? '',
      previousWorkDetailsUrl: json['previous_work_details_url'] ?? '',
    );
  }
}

class ListingResources {
  final int id;
  final String investmentMemoUrl;
  final String financialCalculatorUrl;

  ListingResources({
    required this.id,
    required this.investmentMemoUrl,
    required this.financialCalculatorUrl,
  });

  factory ListingResources.fromJson(Map<String, dynamic> json) {
    return ListingResources(
      id: json['id'] ?? 0,
      investmentMemoUrl: json['investment_memo_url'] ?? '',
      financialCalculatorUrl: json['financial_calculator_url'] ?? '',
    );
  }
}

class ListingInvestmentDetails {
  final int id;
  final String currentFundingDetails;
  final String investmentDeckUrl;
  final String financialPlanUrl;

  ListingInvestmentDetails({
    required this.id,
    required this.currentFundingDetails,
    required this.investmentDeckUrl,
    required this.financialPlanUrl,
  });

  factory ListingInvestmentDetails.fromJson(Map<String, dynamic> json) {
    return ListingInvestmentDetails(
      id: json['id'] ?? 0,
      currentFundingDetails: json['current_funding_details'] ?? '',
      investmentDeckUrl: json['investment_deck_url'] ?? '',
      financialPlanUrl: json['financial_plan_url'] ?? '',
    );
  }
}

class ListingLocation {
  final int id;
  final dynamic latitude;
  final dynamic longitude;
  final String? address;

  ListingLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory ListingLocation.fromJson(Map<String, dynamic> json) {
    return ListingLocation(
      id: json['id'] ?? 0,
      latitude: json['Latitude'] ?? 0.0,
      longitude: json['Longitude'] ?? 0.0,
      address: json['Address'] ?? '',
    );
  }
}

class ListingPropertyDetails {
  final dynamic id;
  final String? propertyOverview;
  final List<String>? propertyPhotos;

  ListingPropertyDetails({
    required this.id,
    this.propertyOverview,
    this.propertyPhotos,
  });

  factory ListingPropertyDetails.fromJson(Map<String, dynamic> json) {
    var photosData = json['Property_Photos'];
    List<String>? photos;

    if (photosData is List) {
      photos = photosData.cast<String>();
    } else if (photosData is String) {
      photos = [photosData];
    }

    return ListingPropertyDetails(
      id: json['id'],
      propertyOverview: json['property_overview'],
      propertyPhotos: photos,
    );
  }
}

class ListingAdminInputs {
  final int id;
  final bool totallyFunded;
  final dynamic targetIrr;
  final dynamic yield;
  final dynamic assetValue;
  final dynamic fundedValue;
  final List<PropertyReview> propertyReview;
  final List<UserReview> userReview;

  ListingAdminInputs({
    required this.id,
    required this.totallyFunded,
    required this.targetIrr,
    required this.yield,
    required this.assetValue,
    required this.fundedValue,
    required this.propertyReview,
    required this.userReview,
  });

  factory ListingAdminInputs.fromJson(Map<String, dynamic> json) {
    return ListingAdminInputs(
      id: json['id'] ?? 0,
      totallyFunded: json['totally_funded'] ?? false,
      targetIrr: json['target_irr'] ?? 0,
      yield: json['yield'] ?? 0,
      assetValue: json['asset_value'] ?? 0,
      fundedValue: json['funded_value'] ?? 0,
      propertyReview: (json['property_review'] as List?)
              ?.map((review) => PropertyReview.fromJson(review))
              .toList() ??
          [],
      userReview: (json['user_review'] as List?)
              ?.map((review) => UserReview.fromJson(review))
              .toList() ??
          [],
    );
  }
}

class PropertyReview {
  final int id;
  final int rating;
  final List<ReviewContent> review;

  PropertyReview({
    required this.id,
    required this.rating,
    required this.review,
  });

  factory PropertyReview.fromJson(Map<String, dynamic> json) {
    return PropertyReview(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      review: (json['review'] as List?)
              ?.map((content) => ReviewContent.fromJson(content))
              .toList() ??
          [],
    );
  }
}

class UserReview {
  final int id;
  final int rating;
  final List<ReviewContent> review;

  UserReview({
    required this.id,
    required this.rating,
    required this.review,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      review: (json['review'] as List?)
              ?.map((content) => ReviewContent.fromJson(content))
              .toList() ??
          [],
    );
  }
}

class ReviewContent {
  final String type;
  final List<ReviewChild> children;

  ReviewContent({
    required this.type,
    required this.children,
  });

  factory ReviewContent.fromJson(Map<String, dynamic> json) {
    return ReviewContent(
      type: json['type'] ?? '',
      children: (json['children'] as List?)
              ?.map((child) => ReviewChild.fromJson(child))
              .toList() ??
          [],
    );
  }
}

class ReviewChild {
  final String text;
  final String type;

  ReviewChild({
    required this.text,
    required this.type,
  });

  factory ReviewChild.fromJson(Map<String, dynamic> json) {
    return ReviewChild(
      text: json['text'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class SavedBy {
  final int id;
  final SavedByAttributes attributes;

  SavedBy({required this.id, required this.attributes});

  factory SavedBy.fromJson(Map<String, dynamic> json) {
    return SavedBy(
      id: json['id'] ?? 0,
      attributes: SavedByAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class SavedByAttributes {
  final String? email;
  final bool confirmed;
  final bool blocked;
  final String username;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final int noOfListings;
  final String? profilePictureUrl;
  final String createdAt;
  final String updatedAt;

  SavedByAttributes({
    this.email,
    required this.confirmed,
    required this.blocked,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.noOfListings,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedByAttributes.fromJson(Map<String, dynamic> json) {
    return SavedByAttributes(
      email: json['email'],
      confirmed: json['confirmed'] ?? false,
      blocked: json['blocked'] ?? false,
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      noOfListings: json['no_of_listings'] ?? 0,
      profilePictureUrl: json['Profile_picture_url'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
