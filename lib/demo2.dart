// import 'package:flutter/material.dart';

// class ApiResponse {
//   final Data data;
//   final Map<String, dynamic> meta;

//   ApiResponse({required this.data, required this.meta});

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       data: Data.fromJson(json['data']),
//       meta: json['meta'] ?? {},
//     );
//   }
// }

// class Data {
//   final int id;
//   final Attributes attributes;

//   Data({required this.id, required this.attributes});

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['id'],
//       attributes: Attributes.fromJson(json['attributes']),
//     );
//   }
// }

// class Attributes {
//   final bool legalAssistance;
//   final bool isListed;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime publishedAt;
//   final ListedBy listedBy;
//   final SiteDetails siteDetails;
//   final UserDetails userDetails;
//   final Resources resources;
//   final InvestmentDetails investmentDetails;
//   final Pricing pricing;
//   final List<Location> location;
//   final PropertyDetails propertyDetails;
//   final AdminInputs adminInputs;
//   final SavedBy savedBy;
//   final double propertyAverageRating;
//   final int propertyReviewCount;
//   final double userAverageRating;
//   final int userReviewCount;
//   final bool isSaved;
//   final int activeViewCount;

//   Attributes({
//     required this.legalAssistance,
//     required this.isListed,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.publishedAt,
//     required this.listedBy,
//     required this.siteDetails,
//     required this.userDetails,
//     required this.resources,
//     required this.investmentDetails,
//     required this.pricing,
//     required this.location,
//     required this.propertyDetails,
//     required this.adminInputs,
//     required this.savedBy,
//     required this.propertyAverageRating,
//     required this.propertyReviewCount,
//     required this.userAverageRating,
//     required this.userReviewCount,
//     required this.isSaved,
//     required this.activeViewCount,
//   });

//   factory Attributes.fromJson(Map<String, dynamic> json) {
//     return Attributes(
//       legalAssistance: json['legal_assistance'],
//       isListed: json['is_listed'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       publishedAt: DateTime.parse(json['publishedAt']),
//       listedBy: ListedBy.fromJson(json['listed_by']['data']),
//       siteDetails: SiteDetails.fromJson(json['site_details']),
//       userDetails: UserDetails.fromJson(json['user_details']),
//       resources: Resources.fromJson(json['Resources']),
//       investmentDetails: InvestmentDetails.fromJson(json['investment_details']),
//       pricing: Pricing.fromJson(json['Pricing']),
//       location: (json['Location'] as List<dynamic>).map((item) => Location.fromJson(item)).toList(),
//       propertyDetails: PropertyDetails.fromJson(json['property_details']),
//       adminInputs: AdminInputs.fromJson(json['Admin_inputs']),
//       savedBy: SavedBy.fromJson(json['saved_by']),
//       propertyAverageRating: json['propertyAverageRating'].toDouble(),
//       propertyReviewCount: json['propertyReviewCount'],
//       userAverageRating: json['userAverageRating'].toDouble(),
//       userReviewCount: json['userReviewCount'],
//       isSaved: json['isSaved'],
//       activeViewCount: json['activeViewCount'],
//     );
//   }
// }

// class ListedBy {
//   final int id;
//   final ListedByAttributes attributes;

//   ListedBy({required this.id, required this.attributes});

//   factory ListedBy.fromJson(Map<String, dynamic> json) {
//     return ListedBy(
//       id: json['id'],
//       attributes: ListedByAttributes.fromJson(json['attributes']),
//     );
//   }
// }

// class ListedByAttributes {
//   final String email;
//   final String? provider;
//   final String? confirmationToken;
//   final bool confirmed;
//   final bool blocked;
//   final String password;
//   final String username;
//   final String firstName;
//   final String lastName;
//   final String mobileNo;
//   final int noOfListings;
//   final String? profilePictureUrl;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   ListedByAttributes({
//     required this.email,
//     this.provider,
//     this.confirmationToken,
//     required this.confirmed,
//     required this.blocked,
//     required this.password,
//     required this.username,
//     required this.firstName,
//     required this.lastName,
//     required this.mobileNo,
//     required this.noOfListings,
//     this.profilePictureUrl,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ListedByAttributes.fromJson(Map<String, dynamic> json) {
//     return ListedByAttributes(
//       email: json['email'],
//       provider: json['provider'],
//       confirmationToken: json['confirmationToken'],
//       confirmed: json['confirmed'],
//       blocked: json['blocked'],
//       password: json['password'],
//       username: json['username'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       mobileNo: json['mobile_no'],
//       noOfListings: json['no_of_listings'],
//       profilePictureUrl: json['Profile_picture_url'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
// }

// class SiteDetails {
//   final int id;
//   final String siteDescription;
//   final int siteTotalArea;
//   final Uri siteBlueprintUrl;

//   SiteDetails({
//     required this.id,
//     required this.siteDescription,
//     required this.siteTotalArea,
//     required this.siteBlueprintUrl,
//   });

//   factory SiteDetails.fromJson(Map<String, dynamic> json) {
//     return SiteDetails(
//       id: json['id'],
//       siteDescription: json['site_description'],
//       siteTotalArea: json['site_total_area'],
//       siteBlueprintUrl: Uri.parse(json['site_blueprint_url']),
//     );
//   }
// }

// class UserDetails {
//   final int id;
//   final String userName;
//   final String companyName;
//   final String countryCode;
//   final String phoneNumber;
//   final String userCity;
//   final String userAddress;
//   final Uri compnayLogoUrl;
//   final Uri previousWorkDetailsUrl;

//   UserDetails({
//     required this.id,
//     required this.userName,
//     required this.companyName,
//     required this.countryCode,
//     required this.phoneNumber,
//     required this.userCity,
//     required this.userAddress,
//     required this.compnayLogoUrl,
//     required this.previousWorkDetailsUrl,
//   });

//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(
//       id: json['id'],
//       userName: json['user_name'],
//       companyName: json['company_name'],
//       countryCode: json['country_code'],
//       phoneNumber: json['phone_number'],
//       userCity: json['user_city'],
//       userAddress: json['user_address'],
//       compnayLogoUrl: Uri.parse(json['compnay_logo_url']),
//       previousWorkDetailsUrl: Uri.parse(json['previous_work_details_url']),
//     );
//   }
// }

// class Resources {
//   final Uri investmentMemoUrl;
//   final Uri financialCalculatorUrl;

//   Resources({
//     required this.investmentMemoUrl,
//     required this.financialCalculatorUrl,
//   });

//   factory Resources.fromJson(Map<String, dynamic> json) {
//     return Resources(
//       investmentMemoUrl: Uri.parse(json['investment_memo_url']),
//       financialCalculatorUrl: Uri.parse(json['financial_calculator_url']),
//     );
//   }
// }

// class InvestmentDetails {
//   final String currentFundingDetails;
//   final Uri investmentDeckUrl;
//   final Uri financialPlanUrl;
//   final List<InvestmentThesis> investmentThesis;

//   InvestmentDetails({
//     required this.currentFundingDetails,
//     required this.investmentDeckUrl,
//     required this.financialPlanUrl,
//     required this.investmentThesis,
//   });

//   factory InvestmentDetails.fromJson(Map<String, dynamic> json) {
//     return InvestmentDetails(
//       currentFundingDetails: json['current_funding_details'],
//       investmentDeckUrl: Uri.parse(json['investment_deck_url']),
//       financialPlanUrl: Uri.parse(json['financial_plan_url']),
//       investmentThesis: (json['investment_thesis'] as List<dynamic>)
//           .map((item) => InvestmentThesis.fromJson(item))
//           .toList(),
//     );
//   }
// }

// class InvestmentThesis {
//   final int id;
//   final String header;
//   final String description;

//   InvestmentThesis({
//     required this.id,
//     required this.header,
//     required this.description,
//   });

//   factory InvestmentThesis.fromJson(Map<String, dynamic> json) {
//     return InvestmentThesis(
//       id: json['id'],
//       header: json['header'],
//       description: json['description'],
//     );
//   }
// }

// class Pricing {
//   final int id;
//   final int totalAmount;
//   final List<AmountBreakdown> amountBreakdown;

//   Pricing({
//     required this.id,
//     required this.totalAmount,
//     required this.amountBreakdown,
//   });

//   factory Pricing.fromJson(Map<String, dynamic> json) {
//     return Pricing(
//       id: json['id'],
//       totalAmount: json['total_amount'],
//       amountBreakdown: (json['amount_breakdown'] as List<dynamic>)
//           .map((item) => AmountBreakdown.fromJson(item))
//           .toList(),
//     );
//   }
// }

// class AmountBreakdown {
//   final int id;
//   final String expenseType;
//   final int cost;

//   AmountBreakdown({
//     required this.id,
//     required this.expenseType,
//     required this.cost,
//   });

//   factory AmountBreakdown.fromJson(Map<String, dynamic> json) {
//     return AmountBreakdown(
//       id: json['id'],
//       expenseType: json['expense_type'],
//       cost: json['cost'],
//     );
//   }
// }

// class Location {
//   final int id;
//   final String locationName;
//   final String locationAddress;

//   Location({
//     required this.id,
//     required this.locationName,
//     required this.locationAddress,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'],
//       locationName: json['location_name'],
//       locationAddress: json['location_address'],
//     );
//   }
// }

// class PropertyDetails {
//   final int id;
//   final String propertyType;
//   final String propertyDescription;

//   PropertyDetails({
//     required this.id,
//     required this.propertyType,
//     required this.propertyDescription,
//   });

//   factory PropertyDetails.fromJson(Map<String, dynamic> json) {
//     return PropertyDetails(
//       id: json['id'],
//       propertyType: json['property_type'],
//       propertyDescription: json['property_description'],
//     );
//   }
// }

// class AdminInputs {
//   final bool hasSiteBlueprint;
//   final bool hasInvestmentDeck;
//   final bool hasFinancialPlan;
//   final bool hasSitePhotos;
//   final bool hasLegalDocuments;

//   AdminInputs({
//     required this.hasSiteBlueprint,
//     required this.hasInvestmentDeck,
//     required this.hasFinancialPlan,
//     required this.hasSitePhotos,
//     required this.hasLegalDocuments,
//   });

//   factory AdminInputs.fromJson(Map<String, dynamic> json) {
//     return AdminInputs(
//       hasSiteBlueprint: json['has_site_blueprint'],
//       hasInvestmentDeck: json['has_investment_deck'],
//       hasFinancialPlan: json['has_financial_plan'],
//       hasSitePhotos: json['has_site_photos'],
//       hasLegalDocuments: json['has_legal_documents'],
//     );
//   }
// }

// class SavedBy {
//   final List<int> userIds;

//   SavedBy({required this.userIds});

//   factory SavedBy.fromJson(Map<String, dynamic> json) {
//     return SavedBy(
//       userIds: (json['user_ids'] as List<dynamic>).map((item) => item as int).toList(),
//     );
//   }
// }
