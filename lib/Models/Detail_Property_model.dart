class ListingResponse {
  final Listing? data;
  final Map<String, dynamic>? meta;

  ListingResponse({this.data, this.meta});

  factory ListingResponse.fromJson(Map<String, dynamic>? json) {
    return ListingResponse(
      data: json?['data'] != null ? Listing.fromJson(json?['data']) : null,
      meta: json?['meta'],
    );
  }
}

class Listing {
  final int? id;
  final Attributes? attributes;

  Listing({this.id, this.attributes});

  factory Listing.fromJson(Map<String, dynamic>? json) {
    return Listing(
      id: json?['id'],
      attributes: json?['attributes'] != null
          ? Attributes.fromJson(json?['attributes'])
          : null,
    );
  }
}

class Attributes {
  final bool? legalAssistance;
  final bool? isListed;
  final String? createdAt;
  final String? updatedAt;
  final String? publishedAt;
  final ListedBy? listedBy;
  final SiteDetails? siteDetails;
  final UserDetails? userDetails;
  final Resources? resources;
  final InvestmentDetails? investmentDetails;
  final Pricing? pricing;
  final List<Location>? location;
  final PropertyDetails? propertyDetails;
  final AdminInputs? adminInputs;
  final SavedBy? savedBy;
  final double? propertyAverageRating;
  final int? propertyReviewCount;
  final double? userAverageRating;
  final int? userReviewCount;
  final bool? isSaved;
  final int? activeViewCount;

  Attributes({
    this.legalAssistance,
    this.isListed,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.listedBy,
    this.siteDetails,
    this.userDetails,
    this.resources,
    this.investmentDetails,
    this.pricing,
    this.location,
    this.propertyDetails,
    this.adminInputs,
    this.savedBy,
    this.propertyAverageRating,
    this.propertyReviewCount,
    this.userAverageRating,
    this.userReviewCount,
    this.isSaved,
    this.activeViewCount,
  });

  factory Attributes.fromJson(Map<String, dynamic>? json) {
    return Attributes(
      legalAssistance: json?['legal_assistance'],
      isListed: json?['is_listed'],
      createdAt: json?['createdAt'],
      updatedAt: json?['updatedAt'],
      publishedAt: json?['publishedAt'],
      listedBy: json?['listed_by']?['data'] != null
          ? ListedBy.fromJson(json?['listed_by']['data'])
          : null,
      siteDetails: json?['site_details'] != null
          ? SiteDetails.fromJson(json?['site_details'])
          : null,
      userDetails: json?['user_details'] != null
          ? UserDetails.fromJson(json?['user_details'])
          : null,
      resources: json?['Resources'] != null
          ? Resources.fromJson(json?['Resources'])
          : null,
      investmentDetails: json?['investment_details'] != null
          ? InvestmentDetails.fromJson(json?['investment_details'])
          : null,
      pricing:
          json?['Pricing'] != null ? Pricing.fromJson(json?['Pricing']) : null,
      location: json?['Location'] != null
          ? List<Location>.from(
              json?['Location'].map((x) => Location.fromJson(x)))
          : null,
      propertyDetails: json?['property_details'] != null
          ? PropertyDetails.fromJson(json?['property_details'])
          : null,
      adminInputs: json?['Admin_inputs'] != null
          ? AdminInputs.fromJson(json?['Admin_inputs'])
          : null,
      savedBy: json?['saved_by']?['data'] != null
          ? SavedBy.fromJson(json?['saved_by']['data'][0])
          : null,
      propertyAverageRating: json?['propertyAverageRating'].toDouble(),
      propertyReviewCount: json?['propertyReviewCount'],
      userAverageRating: json?['userAverageRating'].toDouble(),
      userReviewCount: json?['userReviewCount'],
      isSaved: json?['isSaved'],
      activeViewCount: json?['activeViewCount'],
    );
  }
}

class ListedBy {
  final int? id;
  final ListedByAttributes? attributes;

  ListedBy({
    this.id,
    this.attributes,
  });

  factory ListedBy.fromJson(Map<String, dynamic>? json) {
    return ListedBy(
      id: json?['id'],
      attributes: json?['attributes'] != null
          ? ListedByAttributes.fromJson(json!['attributes'])
          : null,
    );
  }
}

class ListedByAttributes {
  final String? email;
  final String? provider;
  final String? confirmationToken;
  final bool? confirmed;
  final bool? blocked;
  final String? password;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final int? noOfListings;
  final String? profilePictureUrl;
  final String? createdAt;
  final String? updatedAt;

  ListedByAttributes({
    this.email,
    this.provider,
    this.confirmationToken,
    this.confirmed,
    this.blocked,
    this.password,
    this.username,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.noOfListings,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ListedByAttributes.fromJson(Map<String, dynamic>? json) {
    return ListedByAttributes(
      email: json?['email'],
      provider: json?['provider'],
      confirmationToken: json?['confirmationToken'],
      confirmed: json?['confirmed'],
      blocked: json?['blocked'],
      password: json?['password'],
      username: json?['username'],
      firstName: json?['first_name'],
      lastName: json?['last_name'],
      mobileNo: json?['mobile_no'],
      noOfListings: json?['no_of_listings'],
      profilePictureUrl: json?['Profile_picture_url'],
      createdAt: json?['createdAt'],
      updatedAt: json?['updatedAt'],
    );
  }
}

class SiteDetails {
  final int? id;
  final String? siteDescription;
  final int? siteTotalArea;
  final String? siteBlueprintUrl;

  SiteDetails({
    this.id,
    this.siteDescription,
    this.siteTotalArea,
    this.siteBlueprintUrl,
  });

  factory SiteDetails.fromJson(Map<String, dynamic>? json) {
    return SiteDetails(
      id: json?['id'],
      siteDescription: json?['site_description'],
      siteTotalArea: json?['site_total_area'],
      siteBlueprintUrl: json?['site_blueprint_url'],
    );
  }
}

class UserDetails {
  final int? id;
  final String? userName;
  final String? companyName;
  final String? countryCode;
  final String? phoneNumber;
  final String? userCity;
  final String? userAddress;
  final String? compnayLogoUrl;
  final String? previousWorkDetailsUrl;

  UserDetails({
    this.id,
    this.userName,
    this.companyName,
    this.countryCode,
    this.phoneNumber,
    this.userCity,
    this.userAddress,
    this.compnayLogoUrl,
    this.previousWorkDetailsUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic>? json) {
    return UserDetails(
      id: json?['id'],
      userName: json?['user_name'],
      companyName: json?['company_name'],
      countryCode: json?['country_code'],
      phoneNumber: json?['phone_number'],
      userCity: json?['user_city'],
      userAddress: json?['user_address'],
      compnayLogoUrl: json?['compnay_logo_url'],
      previousWorkDetailsUrl: json?['previous_work_details_url'],
    );
  }
}

class Resources {
  final int? id;
  final String? investmentMemoUrl;
  final String? financialCalculatorUrl;

  Resources({
    this.id,
    this.investmentMemoUrl,
    this.financialCalculatorUrl,
  });

  factory Resources.fromJson(Map<String, dynamic>? json) {
    return Resources(
      id: json?['id'],
      investmentMemoUrl: json?['investment_memo_url'],
      financialCalculatorUrl: json?['financial_calculator_url'],
    );
  }
}

class InvestmentDetails {
  final int? id;
  final String? currentFundingDetails;
  final String? investmentDeckUrl;
  final String? financialPlanUrl;
  final List<InvestmentThesis>? investmentThesis;

  InvestmentDetails({
    this.id,
    this.currentFundingDetails,
    this.investmentDeckUrl,
    this.financialPlanUrl,
    this.investmentThesis,
  });

  factory InvestmentDetails.fromJson(Map<String, dynamic>? json) {
    return InvestmentDetails(
      id: json?['id'],
      currentFundingDetails: json?['current_funding_details'],
      investmentDeckUrl: json?['investment_deck_url'],
      financialPlanUrl: json?['financial_plan_url'],
      investmentThesis: json?['investment_thesis'] != null
          ? List<InvestmentThesis>.from(json!['investment_thesis']
              .map((x) => InvestmentThesis.fromJson(x)))
          : null,
    );
  }
}

class InvestmentThesis {
  final int? id;
  final String? header;
  final String? description;

  InvestmentThesis({
    this.id,
    this.header,
    this.description,
  });

  factory InvestmentThesis.fromJson(Map<String, dynamic>? json) {
    return InvestmentThesis(
      id: json?['id'],
      header: json?['header'],
      description: json?['description'],
    );
  }
}

class Pricing {
  final int? id;
  final int? totalAmount;
  final List<AmountBreakdown>? amountBreakdown;

  Pricing({
    this.id,
    this.totalAmount,
    this.amountBreakdown,
  });

  factory Pricing.fromJson(Map<String, dynamic>? json) {
    return Pricing(
      id: json?['id'],
      totalAmount: json?['total_amount'],
      amountBreakdown: json?['amount_breakdown'] != null
          ? List<AmountBreakdown>.from(
              json!['amount_breakdown'].map((x) => AmountBreakdown.fromJson(x)))
          : null,
    );
  }
}

class AmountBreakdown {
  final int? id;
  final String? expenseType;
  final int? cost;

  AmountBreakdown({
    this.id,
    this.expenseType,
    this.cost,
  });

  factory AmountBreakdown.fromJson(Map<String, dynamic>? json) {
    return AmountBreakdown(
      id: json?['id'],
      expenseType: json?['expense_type'],
      cost: json?['cost'],
    );
  }
}

class Location {
  final int? id;
  final double? latitude;
  final double? longitude;
  final String? address;

  Location({this.id, this.latitude, this.longitude, this.address});

  factory Location.fromJson(Map<String, dynamic>? json) {
    return Location(
      id: json?['id'],
      latitude: json?['Latitude']?.toDouble(),
      longitude: json?['Longitude']?.toDouble(),
      address: json?['Address'],
    );
  }
}

class PropertyDetails {
  final int? id;
  final String? propertyOverview;
  final List<String>? propertyPhotos;

  PropertyDetails({
    this.id,
    this.propertyOverview,
    this.propertyPhotos,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic>? json) {
    return PropertyDetails(
      id: json?['id'],
      propertyOverview: json?['property_overview'],
      propertyPhotos: json?['Property_Photos'] != null
          ? List<String>.from(json!['Property_Photos'])
          : null,
    );
  }
}

class AdminInputs {
  final int? id;
  final bool? totallyFunded;
  final dynamic targetIrr;
  final dynamic yield;
  final dynamic assetValue;
  final dynamic fundedValue;
  final List<Review>? propertyReview;
  final List<Review>? userReview;

  AdminInputs({
    this.id,
    this.totallyFunded,
    this.targetIrr,
    this.yield,
    this.assetValue,
    this.fundedValue,
    this.propertyReview,
    this.userReview,
  });

  factory AdminInputs.fromJson(Map<String, dynamic>? json) {
    return AdminInputs(
      id: json?['id'],
      totallyFunded: json?['totally_funded'],
      targetIrr: json?['target_irr'],
      yield: json?['yield'],
      assetValue: json?['asset_value'],
      fundedValue: json?['funded_value'],
      propertyReview: json?['property_review'] != null
          ? List<Review>.from(
              json!['property_review'].map((x) => Review.fromJson(x)))
          : null,
      userReview: json?['user_review'] != null
          ? List<Review>.from(
              json!['user_review'].map((x) => Review.fromJson(x)))
          : null,
    );
  }
}

class Review {
  final int? id;
  final int? rating;
  final List<ReviewContent>? review;

  Review({
    this.id,
    this.rating,
    this.review,
  });

  factory Review.fromJson(Map<String, dynamic>? json) {
    return Review(
      id: json?['id'],
      rating: json?['rating'],
      review: json?['review'] != null
          ? List<ReviewContent>.from(
              json!['review'].map((x) => ReviewContent.fromJson(x)))
          : null,
    );
  }
}

class ReviewContent {
  final String? type;
  final List<ReviewChild>? children;

  ReviewContent({
    this.type,
    this.children,
  });

  factory ReviewContent.fromJson(Map<String, dynamic>? json) {
    return ReviewContent(
      type: json?['type'],
      children: json?['children'] != null
          ? List<ReviewChild>.from(
              json!['children'].map((x) => ReviewChild.fromJson(x)))
          : null,
    );
  }
}

class ReviewChild {
  final String? text;
  final String? type;

  ReviewChild({
    this.text,
    this.type,
  });

  factory ReviewChild.fromJson(Map<String, dynamic>? json) {
    return ReviewChild(
      text: json?['text'],
      type: json?['type'],
    );
  }
}

class SavedBy {
  final int? id;
  final SavedByAttributes? attributes;

  SavedBy({
    this.id,
    this.attributes,
  });

  factory SavedBy.fromJson(Map<String, dynamic>? json) {
    return SavedBy(
      id: json?['id'],
      attributes: json?['attributes'] != null
          ? SavedByAttributes.fromJson(json!['attributes'])
          : null,
    );
  }
}

class SavedByAttributes {
  final String? email;
  final String? provider;
  final String? confirmationToken;
  final bool? confirmed;
  final bool? blocked;
  final String? password;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final int? noOfListings;
  final String? profilePictureUrl;
  final String? createdAt;
  final String? updatedAt;

  SavedByAttributes({
    this.email,
    this.provider,
    this.confirmationToken,
    this.confirmed,
    this.blocked,
    this.password,
    this.username,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.noOfListings,
    this.profilePictureUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedByAttributes.fromJson(Map<String, dynamic>? json) {
    return SavedByAttributes(
      email: json?['email'],
      provider: json?['provider'],
      confirmationToken: json?['confirmationToken'],
      confirmed: json?['confirmed'],
      blocked: json?['blocked'],
      password: json?['password'],
      username: json?['username'],
      firstName: json?['first_name'],
      lastName: json?['last_name'],
      mobileNo: json?['mobile_no'],
      noOfListings: json?['no_of_listings'],
      profilePictureUrl: json?['Profile_picture_url'],
      createdAt: json?['createdAt'],
      updatedAt: json?['updatedAt'],
    );
  }
}
