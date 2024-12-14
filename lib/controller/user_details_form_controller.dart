import 'package:bhumii/Models/User_Listed_model.dart';
import 'package:flutter/material.dart';

class UserDetailsFormController {
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final previousWorkController = TextEditingController();
  final propertyOverviewController = TextEditingController();
  final totalAmountController = TextEditingController();
  final descriptionController = TextEditingController();
  final totalAreaController = TextEditingController();
  final investmentThesisController = TextEditingController();
  final currentfundingController = TextEditingController();
  final locationController = TextEditingController();

  void dispose() {
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    cityController.dispose();
    addressController.dispose();
    previousWorkController.dispose();
    totalAmountController.dispose();
    propertyOverviewController.dispose();
    descriptionController.dispose();
    totalAreaController.dispose();
    investmentThesisController.dispose();
    currentfundingController.dispose();
    locationController.dispose();
  }
}

class EditUserInfoControllers {
  late TextEditingController editnameController;
  late TextEditingController editcompanyController;
  late TextEditingController editphoneController;
  late TextEditingController editcityController;
  late TextEditingController editaddressController;
  late TextEditingController editpropertyOverviewController;
  late TextEditingController editTotalAmountController;
  late TextEditingController editdescriptionController;
  late TextEditingController edittotalAreaController;
  late TextEditingController editinvestmentThesisController;
  late TextEditingController editcurrentfundingController;

  EditUserInfoControllers(ListingData listing) {
    editnameController =
        TextEditingController(text: listing.attributes.userDetails.userName);
    editcompanyController =
        TextEditingController(text: listing.attributes.userDetails.companyName);
    editphoneController =
        TextEditingController(text: listing.attributes.userDetails.phoneNumber);
    editcityController =
        TextEditingController(text: listing.attributes.userDetails.userCity);
    editaddressController =
        TextEditingController(text: listing.attributes.userDetails.userAddress);

    editpropertyOverviewController = TextEditingController(
        text: listing.attributes.propertyDetails.propertyOverview);
    editTotalAmountController = TextEditingController();
    editdescriptionController = TextEditingController(
        text: listing.attributes.siteDetails.siteDescription);
    edittotalAreaController = TextEditingController(
        text: listing.attributes.siteDetails.siteTotalArea.toString());
    editinvestmentThesisController = TextEditingController();
    editcurrentfundingController = TextEditingController(
        text: listing.attributes.investmentDetails.currentFundingDetails);
  }

  void dispose() {
    editnameController.dispose();
    editcompanyController.dispose();
    editphoneController.dispose();
    editcityController.dispose();
    editaddressController.dispose();
    editpropertyOverviewController.dispose();
    editTotalAmountController.dispose();
    editdescriptionController.dispose();
    edittotalAreaController.dispose();
    editinvestmentThesisController.dispose();
    editcurrentfundingController.dispose();
  }
}
