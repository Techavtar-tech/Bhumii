import 'dart:io';

import 'package:bhumii/Screens/ListingScreens/ListPhoto.dart';
import 'package:bhumii/controller/user_details_form_controller.dart';
import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/navigator.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/firebase_upload.dart';
import 'package:bhumii/widgets/Listing_widgets.dart';
import 'package:flutter/material.dart';

class Listproperty extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;

  const Listproperty({super.key, required this.onFinish, required this.onBack});

  @override
  State<Listproperty> createState() => _ListpropertyState();
}

class _ListpropertyState extends State<Listproperty> {
  final _formKey = GlobalKey<FormState>();
  late UserDetailsFormController _controller;
  List<Map<String, dynamic>> selectedFiles = [];
  List<Map<String, dynamic>> selectedImages = [];
  String? logoUrl;
  String? previousWorkUrl;
  bool uploadingFiles = false;
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
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        leading: InkWell(
          onTap: () {
            widget.onBack();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        controller: _controller.nameController,
                      ),
                      SizedBox(height: 1.h),
                      CustomTextFormField(
                        label: 'Name of the Company',
                        hintText: 'Type your company name',
                        isRequired: true,
                        controller: _controller.companyController,
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
                        controller: _controller.phoneController,
                        label: 'Phone Number',
                      ),
                      SizedBox(height: 1.h),
                      CustomTextFormField(
                        label: 'City',
                        hintText: 'Type your city name',
                        isRequired: true,
                        controller: _controller.cityController,
                      ),
                      SizedBox(height: 1.h),
                      CustomTextFormField(
                        label: 'Your Address',
                        hintText: 'Type your address',
                        isRequired: true,
                        maxLines: 3,
                        controller: _controller.addressController,
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
                            setState(() {
                              // Set a flag to indicate that uploading is in progress
                              uploadingFiles = true;
                            });

                            await _uploadFiles();

                            // Navigate only after files are uploaded
                            uploadingFiles = false;
                            navigateToPage(
                              context,
                              Listphoto(
                                onFinish: widget.onFinish,
                                selectedFiles: selectedFiles,
                                selectedImages: selectedImages,
                                userDetails: {
                                  'user_name': _controller.nameController.text,
                                  'company_name':
                                      _controller.companyController.text,
                                  'compnay_logo_url': logoUrl ?? "Empty",
                                  'country_code': '+91',
                                  'phone_number':
                                      _controller.phoneController.text,
                                  'user_city': _controller.cityController.text,
                                  'user_address':
                                      _controller.addressController.text,
                                  'previous_work_details_url':
                                      previousWorkUrl ?? 'Empty'
                                },
                              ),
                            );
                          }
                        },
                        child: uploadingFiles
                            ? CircularProgressIndicator(
                                // Show CircularProgressIndicator while uploading
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.whiteColor),
                              )
                            : Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Maven Pro',
                                  color: AppColors.whiteColor,
                                  fontSize: 24, // Adjust font size as needed
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
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: ChatAndListButton(),
            ),
          ),
        ],
      ),
    );
  }
}
