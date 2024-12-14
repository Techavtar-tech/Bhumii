class UserModel {
  final int id;
  final String email;
  final String? provider;
  final bool confirmed;
  final bool blocked;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String mobileNo;
  final int noOfListings;
  final String? profilePictureUrl;
  final String createdAt;
  final String updatedAt;
  final List<SavedProperty> savedProperties;

  UserModel({
    required this.id,
    required this.email,
    this.provider,
    required this.confirmed,
    required this.blocked,
    this.username,
    this.firstName,
    this.lastName,
    required this.mobileNo,
    required this.noOfListings,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.savedProperties,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      provider: json['provider'],
      confirmed: json['confirmed'] ?? false,
      blocked: json['blocked'] ?? false,
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobileNo: json['mobile_no'] ?? '',
      noOfListings: json['no_of_listings'] ?? 0,
      profilePictureUrl: json['Profile_picture_url'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      savedProperties: (json['saved_properties'] as List<dynamic>?)
          ?.map((e) => SavedProperty.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class SavedProperty {
  final int id;
  final bool legalAssistance;
  final bool isListed;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final PropertyDetails propertyDetails;
  final AdminInputs adminInputs;
  final UserDetails userDetails;

  SavedProperty({
    required this.id,
    required this.legalAssistance,
    required this.isListed,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.propertyDetails,
    required this.adminInputs,
    required this.userDetails,
  });

  factory SavedProperty.fromJson(Map<String, dynamic> json) {
    return SavedProperty(
      id: json['id'] ?? 0,
      legalAssistance: json['legal_assistance'] ?? false,
      isListed: json['is_listed'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      propertyDetails: PropertyDetails.fromJson(json['property_details'] ?? {}),
      adminInputs: AdminInputs.fromJson(json['Admin_inputs'] ?? {}),
      userDetails: UserDetails.fromJson(json['user_details'] ?? {}),
    );
  }
}

class PropertyDetails {
  final int id;
  final String? propertyOverview;
  final List<String>? propertyPhotos;

  PropertyDetails({
    required this.id,
    this.propertyOverview,
    this.propertyPhotos,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    return PropertyDetails(
      id: json['id'] ?? 0,
      propertyOverview: json['property_overview'],
      propertyPhotos: (json['Property_Photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}

class AdminInputs {
  final int id;
  final bool totallyFunded;
  final dynamic targetIrr;
  final dynamic yield;
  final dynamic assetValue;
  final dynamic fundedValue;
  final List<PropertyReview> propertyReviews;

  AdminInputs({
    required this.id,
    required this.totallyFunded,
    this.targetIrr,
    this.yield,
    this.assetValue,
    this.fundedValue,
    required this.propertyReviews,
  });

  factory AdminInputs.fromJson(Map<String, dynamic> json) {
    return AdminInputs(
      id: json['id'] ?? 0,
      totallyFunded: json['totally_funded'] ?? false,
      targetIrr: json['target_irr'],
      yield: json['yield'],
      assetValue: json['asset_value'],
      fundedValue: json['funded_value'],
      propertyReviews: (json['property_review'] as List<dynamic>?)
          ?.map((e) => PropertyReview.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class PropertyReview {
  final int id;
  final int rating;
  final List<Map<String, dynamic>> review;

  PropertyReview({
    required this.id,
    required this.rating,
    required this.review,
  });

  factory PropertyReview.fromJson(Map<String, dynamic> json) {
    return PropertyReview(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      review: (json['review'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [],
    );
  }
}

class UserDetails {
  final int id;
  final String userName;
  final String companyName;
  final String countryCode;
  final String phoneNumber;
  final String userCity;
  final String userAddress;
  final String? companyLogoUrl;
  final String? previousWorkDetailsUrl;

  UserDetails({
    required this.id,
    required this.userName,
    required this.companyName,
    required this.countryCode,
    required this.phoneNumber,
    required this.userCity,
    required this.userAddress,
    this.companyLogoUrl,
    this.previousWorkDetailsUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      companyName: json['company_name'] ?? '',
      countryCode: json['country_code'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userCity: json['user_city'] ?? '',
      userAddress: json['user_address'] ?? '',
      companyLogoUrl: json['compnay_logo_url'],
      previousWorkDetailsUrl: json['previous_work_details_url'],
    );
  }
}