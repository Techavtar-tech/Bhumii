import 'dart:convert';

import 'package:bhumii/Models/Detail_Property_model.dart';
import 'package:bhumii/Models/Saved_model.dart';
import 'package:bhumii/Models/User_Listed_model.dart';
import 'package:bhumii/utils/sharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String Globaltoken = "";

class ApiService {
  static const String baseUrl =
      "https://jolly-symphony-6bd9c0d436.strapiapp.com";

  // cookie will be static
  static const String cookie =
      '__cf_bm=viLJdIUV7UVLbYSSUCrrZRreX7MyBGbmU7vXxIXOMl4-1727259897-1.0.1.1-eV0oy5bb3SIFiPfO7h8BOfzZl9GhZ05bGV8uz5YpwqCkYQRzueUUG3ONsX7PBeh2kmikcj2K8ZIa4l323L_RKg';

  // static String bearerToken =
  //     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNzI3Mjc0MzE1LCJleHAiOjE3Mjk4NjYzMTV9.rYtuU3a1ZOiCKyVsgQ4j4TOmk04_U82DASer5VJZJHI';

  // Dynamically generate the bearer token
  static String get bearerToken => 'Bearer $Globaltoken';

  // Update the global token when logged in
  static void updateGlobalToken(String token) {
    Globaltoken = token;
    UserPreferences.saveToken(token);
    debugPrint("Global Token Updated: $Globaltoken");
  }

  static void clearGlobalToken() {
    Globaltoken = "";
    debugPrint("Global Token Cleared");
  }

  static Future<void> initializeGlobalToken() async {
    String? savedToken = await UserPreferences.getToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      Globaltoken = savedToken;
      debugPrint("Global Token Initialized: $Globaltoken");
    } else {
      debugPrint("No saved token found");
    }
  }

  // Sign In OTP
  static Future<Map<String, dynamic>> signInOtp(String mobileNo) async {
    debugPrint("helloo");

    String url = "$baseUrl/api/auth/sign_in";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie,
      },
      body: jsonEncode({'mobile_no': mobileNo}),
    );
    debugPrint(response.toString());
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send OTP');
    }
  }

//verify otp
  static Future<http.Response> verifyOtp(int otp, String id) async {
    String url = "$baseUrl/api/auth/otp_verify/$id";
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie,
      },
      body: jsonEncode({'otp': otp}),
    );
    return response;
  }

  // Update User Profile
  static Future<http.Response> updateUserProfile(
      int userId, String firstName, String lastName) async {
    String url = "$baseUrl/api/users/$userId";
    var response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
      body: jsonEncode({'first_name': firstName, 'last_name': lastName}),
    );
    return response;
  }

  // Get Listings
  static Future<http.Response> getListings(
      {String? companyName, String? location}) async {
    String url = "$baseUrl/api/listings";

    // Add query parameters if they are provided
    List<String> queryParams = [];
    if (companyName != null && companyName.isNotEmpty) {
      queryParams.add('company_name=$companyName');
    }
    if (location != null && location.isNotEmpty) {
      queryParams.add('location=$location');
    }

    // Append query parameters to the URL if any exist
    if (queryParams.isNotEmpty) {
      url += '?' + queryParams.join('&');
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );
    return response;
  }

  // Create Listing
  static Future<http.Response> createListing(Map<String, dynamic> data) async {
    String url = '$baseUrl/api/listings';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
      body: jsonEncode({'data': data}),
    );

    // Log the request and response for debugging
    print('Request URL: $url');
    print('Request headers: ${jsonEncode(response.request!.headers)}');
    print('Request body: ${jsonEncode({'data': data})}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;
  }

  // Update User Listing
  // static Future<http.Response> updateUserDetails(
  //     int userId, String firstName, String lastName) async {
  //   final String url =
  //       'https://secure-dog-27b6fd15ff.strapiapp.com/api/users/$userId'; // Correct URL
  //   final response = await http.put(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $Globaltoken',
  //     },
  //     body: jsonEncode({
  //       'first_name': firstName,
  //       'last_name': lastName,
  //     }),
  //   );
  //   return response;
  // }

  // Save Property
  static Future<http.Response> getUser() async {
    String url = "$baseUrl/api/users/me?populate[0]=saved_properties";
    return await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
      },
    );
  }

  Future<Listing> fetchListing(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/listings/$id?populate=*'),
      headers: {
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      print('Response of property detail  ${response.body}');
      return Listing.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load listing');
    }
  }

  static Future<http.Response> saveProperty(int listingId) async {
    String url = "$baseUrl/api/listing/save/$listingId";
    return await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );
  }

  // Unsave Property
  static Future<http.Response> unsaveProperty(int listingId) async {
    String url = "$baseUrl/api/listing/save/$listingId";
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );
    return response;
  }

  // Get User Saved Properties
  static Future<http.Response> getUserSavedProperties() async {
    String url = "$baseUrl/api/users/me?populate[0]=saved_properties";
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );
    return response;
  }

  // Method to update mobile number
  static Future<Map<String, dynamic>> updateMobileAPI(String mobileNo) async {
    final url = '$baseUrl/api/auth/update_mobile_no';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
      body: jsonEncode({'mobileNo': '91$mobileNo'}),
    );

    if (response.statusCode == 200) {
      // Parse and return the response body as a Map
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update mobile number');
    }
  }

  // Method to verify mobile number OTP
  static Future<Map<String, dynamic>> verifyMobileOTP(
      String otpLess_request_id, int otp) async {
    final url = '$baseUrl/api/auth/verify_mobile_no/$otpLess_request_id';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
      body: jsonEncode({'otp': otp.toInt()}),
    );

    if (response.statusCode == 200) {
      // Parse and return the response body as a Map
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  // Update Email API
  static Future<Map<String, dynamic>> updateEmailAPI(String email) async {
    final url = '$baseUrl/api/auth/update_email';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      // Parse and return the response body as a Map
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update email');
    }
  }

  // Verify Email OTP API
  static Future<Map<String, dynamic>> verifyEmailOTPAPI(
      int otp, String otpLess_request_id) async {
    final String apiUrl =
        '$baseUrl/api/auth/verify_email/$otpLess_request_id'; // Replace with actual OTP ID
    final Map<String, dynamic> postData = {
      'otp': otp,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Parse and return the response body as a Map
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

  static Future<void> toggleBookmark(int propertyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/listing/toggle/$propertyId'),
      headers: {
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      print("Toggle Api Successful");
    } else {
      print("Status code ${response.statusCode}");
    }
  }

  static Future<http.Response> updateListing(
      int listingId, Map<String, dynamic> data) async {
    final url = '$baseUrl/api/listings/$listingId';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
          'Cookie': cookie,
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  Future<ListingListedResponse> fetchListingResponse() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/my-listings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );

    print(bearerToken);
    if (response.statusCode == 200) {
      print("listed property data: ${response.body}");
      return ListingListedResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load listing data');
    }
  }

  Future<UserModel> fetchUserData() async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/users/me?populate[0]=saved_properties.user_details&populate[1]=saved_properties.Admin_inputs.property_review&populate[2]=saved_properties.property_details'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
        'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      print("saved property data: ${response.body}");
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load user data');
    }
  }

  static Future<bool> updateUserDetails({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
      'Cookie': cookie,
    };
    final body = jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    });

    final response = await http.put(url, headers: headers, body: body);
    try {
      print(response.statusCode);
      return response.statusCode == 200;
    } catch (e) {
      print(response.statusCode);

      print('Error updating user details: $e');
      return false;
    }
  }

  static Future<bool> updateNameDetails({
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
      'Cookie': cookie,
    };
    final body = jsonEncode({
      'first_name': firstName,
      'last_name': lastName,
    });

    final response = await http.put(url, headers: headers, body: body);
    try {
      print(response.statusCode);
      return response.statusCode == 200;
    } catch (e) {
      print(response.statusCode);

      print('Error updating user details: $e');
      return false;
    }
  }

  static Future<bool> updateProfilePicture(
      {required String profile_picture_url}) async {
    final url = Uri.parse('$baseUrl/api/auth/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
      'Cookie': cookie,
    };
    final body = jsonEncode({
      'profile_picture_url': profile_picture_url,
    });

    final response = await http.put(url, headers: headers, body: body);
    try {
      print(response.statusCode);
      return response.statusCode == 200;
    } catch (e) {
      print(response.statusCode);

      print('Error updating user details: $e');
      return false;
    }
  }

//google signin

  static Future<String> googleSignInApi(String accessToken) async {
    final String apiUrl = '$baseUrl/api/auth/google_access_token';

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie,
      },
      body: jsonEncode({'accessToken': accessToken}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
          jsonDecode(response.body) as Map<String, dynamic>;

      // Extract the token value
      final String token = responseBody['data']['token'];

      // Print the token value
      // print('Token: $token');
      updateGlobalToken(token);
      // Globaltoken = token;
      // print('Globaltoken = $Globaltoken');

      return token; // Optionally return the token
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: ${response.body}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token');
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  static Future<String> deleteApi() async {
    final String apiUrl = '$baseUrl/api/auth/delete_account';

    final http.Response response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie,
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      return "User account deleted successfully.";
    } else if (response.statusCode == 400) {
      throw Exception('Bad request: ${response.body}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token');
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }
}
