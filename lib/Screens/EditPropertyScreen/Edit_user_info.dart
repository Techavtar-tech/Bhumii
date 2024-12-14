import 'dart:io';

import 'package:bhumii/Models/User_Listed_model.dart';
import 'package:bhumii/Screens/EditPropertyScreen/Edit_listing.dart';
import 'package:bhumii/controller/user_details_form_controller.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/firebase_upload.dart';
import 'package:bhumii/widgets/Listing_widgets.dart';
import 'package:flutter/material.dart';

class EditUserPropertyInfo extends StatefulWidget {
  final VoidCallback onFinish;
  final ListingData listing;
  EditUserPropertyInfo(
      {super.key, required this.listing, required this.onFinish});

  @override
  State<EditUserPropertyInfo> createState() => _EditUserPropertyInfoState();
}

class _EditUserPropertyInfoState extends State<EditUserPropertyInfo> {
  late EditUserInfoControllers _controllers;

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> selectedFiles = [];
  List<Map<String, dynamic>> selectedImages = [];
  String? logoUrl;
  String? previousWorkUrl;

  @override
  void initState() {
    super.initState();
    _controllers = EditUserInfoControllers(widget.listing);
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _uploadFiles() async {
    List<Future<String?>> uploadTasks = [];

    if (selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        uploadTasks.add(uploadPhoto(image['image'], image['name']));
      }
    }

    if (selectedFiles.isNotEmpty) {
      for (var file in selectedFiles) {
        uploadTasks.add(uploadPDF(file['file'], file['name']));
      }
    }

    List<String?> downloadUrls = await Future.wait(uploadTasks);

    if (selectedImages.isNotEmpty) {
      logoUrl = downloadUrls[0];
    }
    if (selectedFiles.isNotEmpty) {
      previousWorkUrl = downloadUrls[1];
    }
  }

  void _onFilePicked(File? file, String name) {
    setState(() {
      if (file != null) {
        // If a file is selected, add it to the list
        selectedFiles.add({"file": file, "name": name});
      } else {
        // If file is null (removed or invalid), remove it from the list if it exists
        selectedFiles.removeWhere((item) => item["name"] == name);
      }
    });
  }

  void _onImageChanged(File image, String name) {
    setState(() {
      selectedImages.add({"image": image, "name": name});
    });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            const StepperWidget(),
            SizedBox(height: 3.h),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    label: 'Your Name',
                    hintText: 'Enter your name',
                    isRequired: true,
                    controller: _controllers.editnameController,
                  ),
                  SizedBox(height: 1.h),
                  CustomTextFormField(
                    label: 'Name of the Company',
                    hintText: 'Type your company name',
                    isRequired: true,
                    controller: _controllers.editcompanyController,
                  ),
                  SizedBox(height: 2.h),
                  AttachLogoButton(
                    onImageChanged: (File? image) {
                      if (image != null) {
                        _onImageChanged(image, "Attach Logo");
                      }
                    },
                    text: 'Attach Logo',
                  ),
                  SizedBox(height: 2.h),
                  PhoneNumberFormField(
                    controller: _controllers.editphoneController,
                    label: 'Phone Number',
                  ),
                  SizedBox(height: 1.h),
                  CustomTextFormField(
                    label: 'City',
                    hintText: 'Type your city name',
                    isRequired: true,
                    controller: _controllers.editcityController,
                  ),
                  SizedBox(height: 1.h),
                  CustomTextFormField(
                    label: 'Your Address',
                    hintText: 'Type your address',
                    isRequired: true,
                    maxLines: 3,
                    controller: _controllers.editaddressController,
                  ),
                  SizedBox(height: 1.h),
                  UploadDocumentField(
                    hint: '',
                    label: 'Details of Previous Work',
                    isSubmitted: false,
                    onFilePicked: (File? file) {
                      _onFilePicked(file, "Details of Previous Work");
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _uploadFiles();
                        print(widget.listing.id);

                        navigateToPage(
                          context,
                          editListing(
                            listing: widget.listing,
                            onFinish: () {
                              widget.onFinish();
                            },
                            selectedFiles: selectedFiles,
                            selectedImages: selectedImages,
                            userDetails: {
                              'user_name': _controllers.editnameController.text,
                              'company_name':
                                  _controllers.editcompanyController.text,
                              'compnay_logo_url': logoUrl ?? "Empty",
                              'country_code': '+91',
                              'phone_number':
                                  _controllers.editphoneController.text,
                              'user_city': _controllers.editcityController.text,
                              'user_address':
                                  _controllers.editaddressController.text,
                              'previous_work_details_url':
                                  previousWorkUrl ?? 'Empty'
                            },
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Maven Pro',
                        color: AppColors.whiteColor,
                        fontSize: 4.w,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
