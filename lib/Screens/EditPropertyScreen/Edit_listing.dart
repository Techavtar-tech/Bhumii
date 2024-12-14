import 'dart:io';

import 'package:bhumii/Models/User_Listed_model.dart';
import 'package:bhumii/controller/user_details_form_controller.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/firebase_upload.dart';
import 'package:bhumii/widgets/Listing_widgets.dart';
import 'package:flutter/material.dart';

class editListing extends StatefulWidget {
  final VoidCallback? onFinish;
  final ListingData listing;
  final List<Map<String, dynamic>> selectedFiles; // Add field name for files
  final List<Map<String, dynamic>> selectedImages; // Add field name for images
  final Map<String, dynamic> userDetails; // Add userDetails from Listproperty

  const editListing({
    super.key,
    required this.selectedFiles,
    required this.selectedImages,
    required this.userDetails,
    required this.listing,
    required this.onFinish,
  });

  @override
  State<editListing> createState() => editListingState();
}

class editListingState extends State<editListing> {
  late EditUserInfoControllers _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  bool _isLoading = false;
  final List<HeaderField> _investmentThesisFields = [];
  final List<BreakdownField> _breakdownFields = [];
  List<File> _selectedImages = [];
  void _onFilePicked(File? file, String name) {
    setState(() {
      if (file != null) {
        // If a file is selected, add it to the list
        widget.selectedFiles.add({"file": file, "name": name});
      } else {
        // If file is null (removed or invalid), remove it from the list if it exists
        widget.selectedFiles.removeWhere((item) => item["name"] == name);
      }
    });
  }

  void _onImagePicked(File image, String name) {
    setState(() {
      widget.selectedImages.add({"image": image, "name": name});
    });
  }

  void _onImagesSelected(List<File> images) {
    setState(() {
      _selectedImages = images;
    });
  }

  Future<List<String>> _uploadPhotos() async {
    List<String> photoUrls = await uploadPropertyPhotos(_selectedImages);
    print("Uploaded photo URLs: $photoUrls");
    return photoUrls;
  }

  void _finish() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      List<String> editphotoUrls = await _uploadPhotos();
      List<String> editinvestmentDeckUrls = [];
      List<String> editfinancialPlanUrls = [];
      List<String> editinvestmentMemoUrls = [];
      List<String> editfinancialCalculatorUrls = [];
      String editsiteBlueprintUrl = '';

      for (Map<String, dynamic> fileMap in widget.selectedFiles) {
        File file = fileMap["file"];
        String name = fileMap["name"];

        String? uploadSuccess = await uploadPDF(file, name);
        if (uploadSuccess != null) {
          if (name == "investment_deck") {
            editinvestmentDeckUrls.add(uploadSuccess);
          } else if (name == "financial_plan") {
            editfinancialPlanUrls.add(uploadSuccess);
          } else if (name == "financial_calculator") {
            editfinancialCalculatorUrls.add(uploadSuccess);
          } else if (name == "investment_memo") {
            editinvestmentMemoUrls.add(uploadSuccess);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to upload ${file.path.split("/").last}. Please try again.'),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      for (Map<String, dynamic> imageMap in widget.selectedImages) {
        File image = imageMap["image"];
        String name = imageMap["name"];

        if (name == "site_blueprint") {
          // Upload the site blueprint photo and store its URL
          editsiteBlueprintUrl = await uploadPhoto(image, name) ?? '';
        } else {
          String? uploadImageSuccess = await uploadPhoto(image, name);
          if (uploadImageSuccess != null) {
            editphotoUrls.add(uploadImageSuccess);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Failed to upload ${image.path.split("/").last}. Please try again.'),
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }
      }

      // Gather investment thesis data
      List<Map<String, String>> investmentThesis = [];
      for (var headerField in _investmentThesisFields) {
        investmentThesis.add({
          'header': headerField.headerController.text,
          'description': headerField.descriptionController.text,
        });
      }

      // Gather amount breakdown data
      List<Map<String, dynamic>> amountBreakdown = [];
      for (var breakdownField in _breakdownFields) {
        amountBreakdown.add({
          'expense_type': breakdownField.nameController.text,
          'cost': int.parse(breakdownField.amountController.text),
        });
      }

      // Create listing data
      Map<String, dynamic> listingData = {
        "data": {
          'site_details': {
            'site_description': _controller.editdescriptionController.text,
            'site_total_area':
                int.parse(_controller.edittotalAreaController.text),
            'site_blueprint_url': editsiteBlueprintUrl
          },
          "user_details": widget.userDetails,
          'Resources': {
            'financial_calculator_url': editfinancialCalculatorUrls.isNotEmpty
                ? editfinancialCalculatorUrls[0]
                : '',
            'investment_memo_url': editinvestmentMemoUrls.isNotEmpty
                ? editinvestmentMemoUrls[0]
                : ''
          },
          'investment_details': {
            'current_funding_details':
                _controller.editcurrentfundingController.text,
            'investment_thesis': investmentThesis,
            'investment_deck_url': editinvestmentDeckUrls.isNotEmpty
                ? editinvestmentDeckUrls[0]
                : '',
            'financial_plan_url':
                editfinancialPlanUrls.isNotEmpty ? editfinancialPlanUrls[0] : ''
          },
          'Pricing': {
            'total_amount':
                int.parse(_controller.editTotalAmountController.text),
            'amount_breakdown': amountBreakdown
          },
          'property_details': {
            'Property_Photos': editphotoUrls,
            'property_overview':
                _controller.editpropertyOverviewController.text,
          }
        }
      };

      // Call the API to create listing
      var response =
          await ApiService.updateListing(widget.listing.id, listingData);
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response);
        // widget.onFinish!();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Updated listing.'),
          ),
        );
      } else {
        print('Failed to update listing. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to Update listing. Please try again.'),
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onImageChanged(File? image, String name) {
    setState(() {
      if (image != null) {
        widget.selectedImages.add({"image": image, "name": name});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = EditUserInfoControllers(widget.listing);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: InkWell(
          onTap: () {
            navigateBack(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepperWidgetPhoto(),
                    SizedBox(height: 2.h),
                    Text(
                      'Upload Property Photos',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          color: AppColors.blackColor,
                          fontSize: 4.w,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      'Add your documents here, and you can upload up to 5 files max',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          color: AppColors.blackColor,
                          fontSize: 2.9.w,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 2.h),
                    // AddPhotoWidget(  onImagesSelected: _onImagesSelected,),
                    SizedBox(height: 2.h),
                    CustomTextFormField(
                      controller: _controller.editpropertyOverviewController,
                      label: 'Property Overview',
                      hintText: 'Type your property overview',
                      isRequired: true,
                      maxLines: 1,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Site details',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          color: AppColors.blackColor,
                          fontSize: 4.w,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2.h),
                    CustomTextFormField(
                      controller: _controller.editdescriptionController,
                      label: 'Description',
                      hintText: 'Type your company name',
                      isRequired: true,
                      maxLines: 1,
                    ),
                    SizedBox(height: 1.h),
                    CustomTextFormField(
                      label: 'Total Area',
                      hintText: 'Enter Total Area',
                      isRequired: true,
                      maxLines: 1,
                      controller: _controller.edittotalAreaController,
                    ),
                    AttachLogoButton(
                      onImageChanged: (image) =>
                          _onImageChanged(image, "site_blueprint"),
                      text: 'Attach Site Blueprint Photo',
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Investment Details',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          color: AppColors.blackColor,
                          fontSize: 4.w,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2.h),
                    InvestmentThesisInput(
                      headerFields: _investmentThesisFields,
                    ),
                    SizedBox(height: 3.h),
                    CustomTextFormField(
                      label: 'Current funding Details',
                      hintText: 'Type funding details',
                      isRequired: true,
                      maxLines: 3,
                      controller: _controller.editcurrentfundingController,
                    ),
                    SizedBox(height: 1.h),
                    UploadDocumentField(
                      hint: 'Upload in .pdf format not more than 2 MB',
                      label: 'Investment Deck',
                      isSubmitted: _isSubmitted,
                      onFilePicked: (file) =>
                          _onFilePicked(file, "investment_deck"),
                    ),
                    SizedBox(height: 3.h),
                    UploadDocumentField(
                      hint: 'Upload in .pdf format not more than 2 MB',
                      label: 'Financial Plan',
                      isSubmitted: _isSubmitted,
                      onFilePicked: (file) =>
                          _onFilePicked(file, "financial_plan"),
                    ),
                    SizedBox(height: 4.h),
                    PricingForm(
                      amountcontroller: _controller.editTotalAmountController,
                      breakdownFields: _breakdownFields,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Resources',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          color: AppColors.blackColor,
                          fontSize: 4.w,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 1.h),
                    UploadDocumentField(
                      hint: 'Upload in .pdf format not more than 2 MB',
                      label: 'Investment Memo',
                      isSubmitted: _isSubmitted,
                      onFilePicked: (file) =>
                          _onFilePicked(file, "investment_memo"),
                    ),
                    SizedBox(height: 3.h),
                    UploadDocumentField(
                      hint: 'Upload in .pdf format not more than 2 MB',
                      label: 'Financial Calculator',
                      isSubmitted: _isSubmitted,
                      onFilePicked: (file) =>
                          _onFilePicked(file, "financial_calculator"),
                    ),
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () {
                        _finish();
                      },
                      child: Container(
                        height: 6.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Finish",
                            style: TextStyle(
                                fontFamily: 'Maven Pro',
                                color: AppColors.whiteColor,
                                fontSize: 4.w,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
