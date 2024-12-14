class ListingResponse {
  final List<Listing> data;
  final Map<String, dynamic> meta;

  ListingResponse({required this.data, required this.meta});

  factory ListingResponse.fromJson(Map<String, dynamic> json) {
    return ListingResponse(
      data: (json['data'] as List?)
              ?.map((item) => Listing.fromJson(item))
              .toList() ??
          [],
      meta: json['meta'] ?? {},
    );
  }
}

class Listing {
  final dynamic id;
  final ListingAttributes attributes;

  Listing({required this.id, required this.attributes});

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
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
  final UserDetails? userDetails;
  final List<Location> location;
  final PropertyDetails? propertyDetails;
  final AdminInputs? adminInputs;
  final SavedBy? savedBy;
  bool isSaved;

  ListingAttributes({
    required this.legalAssistance,
    required this.isListed,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.userDetails,
    required this.location,
    this.propertyDetails,
    this.adminInputs,
    this.savedBy,
    required this.isSaved,
  });

  factory ListingAttributes.fromJson(Map<String, dynamic> json) {
    return ListingAttributes(
      legalAssistance: json['legal_assistance'] ?? false,
      isListed: json['is_listed'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
      location: (json['Location'] as List?)
              ?.map((item) => Location.fromJson(item))
              .toList() ??
          [],
      propertyDetails: json['property_details'] != null
          ? PropertyDetails.fromJson(json['property_details'])
          : null,
      adminInputs: json['Admin_inputs'] != null
          ? AdminInputs.fromJson(json['Admin_inputs'])
          : null,
      savedBy:
          json['saved_by'] != null ? SavedBy.fromJson(json['saved_by']) : null,
      isSaved: json['isSaved'] ?? false,
    );
  }

  double get fundingPercentage => adminInputs?.fundingPercentage ?? 0.0;
}

class UserDetails {
  final dynamic id;
  final String? userName;
  final String? companyName;
  final String? countryCode;
  final String? phoneNumber;
  final String? userCity;
  final String? userAddress;
  final String? companyLogoUrl;
  final String? previousWorkDetailsUrl;

  UserDetails({
    required this.id,
    this.userName,
    this.companyName,
    this.countryCode,
    this.phoneNumber,
    this.userCity,
    this.userAddress,
    this.companyLogoUrl,
    this.previousWorkDetailsUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      userName: json['user_name'],
      companyName: json['company_name'],
      countryCode: json['country_code'],
      phoneNumber: json['phone_number'],
      userCity: json['user_city'],
      userAddress: json['user_address'],
      companyLogoUrl: json['compnay_logo_url'],
      previousWorkDetailsUrl: json['previous_work_details_url'],
    );
  }
}

class Location {
  final dynamic id;
  final double? latitude;
  final double? longitude;
  final String? address;

  Location({
    required this.id,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      latitude: json['Latitude']?.toDouble(),
      longitude: json['Longitude']?.toDouble(),
      address: json['Address'] ?? '',
    );
  }
}

class PropertyDetails {
  final dynamic id;
  final String? propertyOverview;
  final List<String>? propertyPhotos;

  PropertyDetails({
    required this.id,
    this.propertyOverview,
    this.propertyPhotos,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    var photosData = json['Property_Photos'];
    List<String>? photos;

    if (photosData is List) {
      photos = photosData.cast<String>();
    } else if (photosData is String) {
      photos = [photosData];
    }

    return PropertyDetails(
      id: json['id'],
      propertyOverview: json['property_overview'],
      propertyPhotos: photos,
    );
  }
}

class AdminInputs {
  final dynamic id;
  final bool totallyFunded;
  final double targetIrr;
  final double yield;
  final double assetValue;
  final double fundedValue;

  AdminInputs({
    required this.id,
    required this.totallyFunded,
    required this.targetIrr,
    required this.yield,
    required this.assetValue,
    required this.fundedValue,
  });

  factory AdminInputs.fromJson(Map<String, dynamic> json) {
    return AdminInputs(
      id: json['id'],
      totallyFunded: json['totally_funded'] ?? false,
      targetIrr: (json['target_irr'] ?? 0).toDouble(),
      yield: (json['yield'] ?? 0).toDouble(),
      assetValue: (json['asset_value'] ?? 0).toDouble(),
      fundedValue: (json['funded_value'] ?? 0).toDouble(),
    );
  }

  double get fundingPercentage {
    if (assetValue == 0) return 0.0;
    return (fundedValue / assetValue) * 100;
  }
}

class SavedBy {
  final List<SavedByUser> data;

  SavedBy({required this.data});

  factory SavedBy.fromJson(Map<String, dynamic> json) {
    return SavedBy(
      data: (json['data'] as List?)
              ?.map((item) => SavedByUser.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SavedByUser {
  final int id;
  final SavedByUserAttributes attributes;

  SavedByUser({required this.id, required this.attributes});

  factory SavedByUser.fromJson(Map<String, dynamic> json) {
    return SavedByUser(
      id: json['id'],
      attributes: SavedByUserAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class SavedByUserAttributes {
  final String? password;
  final String? email;
  final String? provider;
  final String? confirmationToken;
  final bool confirmed;
  final bool blocked;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final dynamic noOfListings;
  final String? profilePictureUrl;
  final String? createdAt;
  final String? updatedAt;

  SavedByUserAttributes({
    this.password,
    this.email,
    this.provider,
    this.confirmationToken,
    required this.confirmed,
    required this.blocked,
    this.username,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.noOfListings,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedByUserAttributes.fromJson(Map<String, dynamic> json) {
    return SavedByUserAttributes(
      password: json['password'],
      email: json['email'],
      provider: json['provider'],
      confirmationToken: json['confirmationToken'],
      confirmed: json['confirmed'] ?? false,
      blocked: json['blocked'] ?? false,
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobileNo: json['mobile_no'],
      noOfListings: json['no_of_listings'],
      profilePictureUrl: json['Profile_picture_url'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
