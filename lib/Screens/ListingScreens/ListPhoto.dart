import 'dart:io';

import 'package:bhumii/Screens/ListingScreens/FinishScreen.dart';
import 'package:bhumii/controller/user_details_form_controller.dart';
import 'package:bhumii/utils/Api_service.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/firebase_upload.dart';
import 'package:bhumii/widgets/Listing_widgets.dart';
import 'package:flutter/material.dart';

class Listphoto extends StatefulWidget {
  final VoidCallback onFinish;
  final List<Map<String, dynamic>> selectedFiles; // Add field name for files
  final List<Map<String, dynamic>> selectedImages; // Add field name for images
  final Map<String, dynamic> userDetails; // Add userDetails from Listproperty

  const Listphoto({
    super.key,
    required this.onFinish,
    required this.selectedFiles,
    required this.selectedImages,
    required this.userDetails,
  });

  @override
  State<Listphoto> createState() => _ListphotoState();
}

class _ListphotoState extends State<Listphoto> {
  late UserDetailsFormController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  bool _isChecked = false;
  bool _isLoading = false;
  final List<HeaderField> _investmentThesisFields = [];
  final List<BreakdownField> _breakdownFields = [];
  String _latitude = '';
  String _longitude = '';
  String address = '';
  List<File> _selectedImages = [];
  bool _isPhotoValid = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

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
    await Future.delayed(Duration.zero);
    if (_formKey.currentState!.validate() && _isChecked && _isPhotoValid) {
      List<String> photoUrls = await _uploadPhotos();
      List<String> investmentDeckUrls = [];
      List<String> financialPlanUrls = [];
      List<String> investmentMemoUrls = [];
      List<String> financialCalculatorUrls = [];
      String siteBlueprintUrl = '';

      if (photoUrls.isEmpty) {
        setState(() {
          _isPhotoValid = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select at least one photo.'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      for (Map<String, dynamic> fileMap in widget.selectedFiles) {
        File file = fileMap["file"];
        String name = fileMap["name"];

        String? uploadSuccess = await uploadPDF(file, name);
        if (uploadSuccess != null) {
          if (name == "investment_deck") {
            investmentDeckUrls.add(uploadSuccess);
          } else if (name == "financial_plan") {
            financialPlanUrls.add(uploadSuccess);
          } else if (name == "financial_calculator") {
            financialCalculatorUrls.add(uploadSuccess);
          } else if (name == "investment_memo") {
            investmentMemoUrls.add(uploadSuccess);
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
          siteBlueprintUrl = await uploadPhoto(image, name) ?? '';
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
        String name = breakdownField.nameController.text.trim();
        String amountText = breakdownField.amountController.text.trim();

        // Skip empty entries
        if (name.isNotEmpty && amountText.isNotEmpty) {
          int? amount = int.tryParse(amountText);
          if (amount != null) {
            amountBreakdown.add({
              'expense_type': name,
              'cost': amount,
            });
          }
        }
      }
      print('dats is $amountBreakdown');
      print("this is address $address");
      // Create listing data
      Map<String, dynamic> listingData = {
        'site_details': {
          'site_description': _controller.descriptionController.text,
          'site_total_area': int.parse(_controller.totalAreaController.text),
          'site_blueprint_url': siteBlueprintUrl
        },
        "user_details": widget.userDetails,
        'legal_assistance': _isChecked,
        'investment_details': {
          'current_funding_details': _controller.currentfundingController.text,
          'investment_thesis': investmentThesis,
          'investment_deck_url':
              investmentDeckUrls.isNotEmpty ? investmentDeckUrls[0] : '',
          'financial_plan_url':
              financialPlanUrls.isNotEmpty ? financialPlanUrls[0] : ''
        },
        'Pricing': {
          'total_amount': _controller.totalAmountController.text,
          'amount_breakdown': amountBreakdown
        },
        'property_details': {
          'Property_Photos': photoUrls,
          'property_overview': _controller.propertyOverviewController.text,
        },
        'Location': [
          {'Latitude': _latitude, 'Longitude': _longitude, "Address": address}
        ],
        'Resources': {
          'financial_calculator_url': financialCalculatorUrls.isNotEmpty
              ? financialCalculatorUrls[0]
              : '',
          'investment_memo_url':
              investmentMemoUrls.isNotEmpty ? investmentMemoUrls[0] : ''
        }
      };

      // Call the API to create listing
      var response = await ApiService.createListing(listingData);
      if (response.statusCode == 200) {
        print(response.statusCode);
        navigateToPage(context, Finishscreen(onFinish: widget.onFinish));
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create listing. Please try again.'),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = '';

      if (!_formKey.currentState!.validate()) {
        errorMessage += 'Please fill in all required fields. ';
      }
      if (!_isPhotoValid) {
        errorMessage += 'At least one photo must be selected. ';
      }
      if (!_isChecked) {
        errorMessage += 'Please check the box.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage.trim()),
      ));
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

  void _onLocationChanged(
      String latitude, String longitude, String Newaddress) {
    setState(() {
      _latitude = latitude;
      _longitude = longitude;
      address = Newaddress;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = UserDetailsFormController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      _isSubmitted = true;
    });
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All documents are valid')),
      );
    }
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
                    AddPhotoWidget(
                      onImagesSelected: (List<File> images) {
                        _onImagesSelected(images);
                      },
                      onValidationChanged: (bool isValid) {
                        setState(() {
                          _isPhotoValid = isValid;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),
                    CustomTextFormField(
                      controller: _controller.propertyOverviewController,
                      label: 'Property Overview',
                      hintText: 'Type your property overview',
                      isRequired: true,
                      maxLines: 1,
                    ),
                    SizedBox(height: 1.h),
                    LocationField(
                      onLocationChanged: _onLocationChanged,
                    ),
                    SizedBox(height: 4.h),
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
                      controller: _controller.descriptionController,
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
                      controller: _controller.totalAreaController,
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
                      controller: _controller.currentfundingController,
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
                      amountcontroller: _controller.totalAmountController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: AppColors.primaryColor,
                          value: _isChecked,
                          onChanged: _toggleCheckbox,
                        ),
                        Text('I need legal and accounting assistance.'),
                      ],
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
