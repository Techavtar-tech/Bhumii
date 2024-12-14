// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bhumii/utils/constants/colors.dart';
import 'package:bhumii/utils/constants/size_cofig.dart';
import 'package:bhumii/utils/whatsappLaunch.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class StepperWidget extends StatelessWidget {
  const StepperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.6.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 2.h,
                width: 2.h,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 101, 209, 103),
                        width: 4),
                    borderRadius: BorderRadius.circular(20)),
              ),
              Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width - 37.w,
                  color: const Color.fromARGB(255, 187, 187, 187)),
              Container(
                height: 2.h,
                width: 2.h,
                decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    border: Border.all(
                        color: const Color.fromARGB(255, 187, 187, 187),
                        width: 4),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Details',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromRGBO(171, 217, 111, 1),
                  fontSize: 4.w,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Property Details',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromARGB(255, 187, 187, 187),
                  fontSize: 4.w,
                  fontWeight: FontWeight.w600),
            )
          ],
        )
      ],
    );
  }
}

class StepperWidgetPhoto extends StatelessWidget {
  const StepperWidgetPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.6.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 2.h,
                width: 2.h,
                child: const Icon(
                  Icons.check_circle,
                  color: Color.fromARGB(255, 101, 209, 103),
                ),
              ),
              Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width - 37.w,
                  color: const Color.fromARGB(255, 101, 209, 103)),
              Container(
                height: 2.h,
                width: 2.h,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 101, 209, 103),
                        width: 4),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Details',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromRGBO(171, 217, 111, 1),
                  fontSize: 4.w,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Property Details',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromRGBO(171, 217, 111, 1),
                  fontSize: 4.w,
                  fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRequired;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isRequired = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
                fontFamily: 'Maven Pro',
                color: const Color.fromRGBO(77, 76, 76, 1),
                fontSize: 4.w,
                fontWeight: FontWeight.w500),
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                fontFamily: 'Maven Pro',
                color: const Color.fromRGBO(214, 214, 214, 1),
                fontSize: 4.w,
                fontWeight: FontWeight.w400),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          maxLines: maxLines,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  return null;
                }
              : null,
        ),
        SizedBox(height: 1.h),
      ],
    );
  }
}

class AttachLogoButton extends StatefulWidget {
  final String text;
  final Function(File?) onImageChanged;

  const AttachLogoButton(
      {Key? key, required this.text, required this.onImageChanged})
      : super(key: key);

  @override
  _AttachLogoButtonState createState() => _AttachLogoButtonState();
}

class _AttachLogoButtonState extends State<AttachLogoButton> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageChanged(_image);
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_image != null)
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: _removeImage,
              ),
            ],
          )
        else
          InkWell(
            onTap: _pickImage,
            child: Row(
              children: [
                Transform.rotate(
                  angle: 315 * (3.14159 / 180),
                  child: Icon(
                    Icons.attachment_outlined,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: 'Maven Pro',
                    color: AppColors.primaryColor,
                    fontSize: 4.w,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class ChatAndListButton extends StatelessWidget {
  const ChatAndListButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            launchWhatsApp(context);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Chat and List',
                    style: TextStyle(
                        letterSpacing: 1,
                        // fontFamily: 'Maven Pro',
                        color: AppColors.whiteColor,
                        fontSize: 4.w,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Image.asset(
                    'assets/images/Logo/whatsApp.png',
                    height: 30,
                    width: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PhoneNumberFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const PhoneNumberFormField({
    Key? key,
    required this.controller,
    this.label = 'Phone Number',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                    fontFamily: 'Maven Pro',
                    color: const Color.fromRGBO(77, 76, 76, 1),
                    fontSize: 4.w,
                    fontWeight: FontWeight.w500),
              ),
              const TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            hintStyle: TextStyle(
              fontFamily: 'Maven Pro',
              color: Color.fromRGBO(214, 214, 214, 1),
              fontSize: 4.w,
              fontWeight: FontWeight.w400,
            ),
            prefixText: '+91  ',
            prefixStyle: TextStyle(
              fontFamily: 'Maven Pro',
              color: Colors.black,
              fontSize: 4.w,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            // Remove any non-digit characters from the input
            String digits = value.replaceAll(RegExp(r'\D'), '');
            if (digits.length != 10) {
              return 'Phone number must be 10 digits';
            }
            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AddPhotoWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final Function(bool) onValidationChanged;

  const AddPhotoWidget({
    Key? key,
    required this.onImagesSelected,
    required this.onValidationChanged,
  }) : super(key: key);

  @override
  State<AddPhotoWidget> createState() => _AddPhotoWidgetState();
}

class _AddPhotoWidgetState extends State<AddPhotoWidget> {
  final List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _showError = false;

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          if (_imageFiles.length < 5) {
            _imageFiles.add(File(pickedFile.path));
          } else {
            break; // Stop adding if we've reached 5 images
          }
        }
        _showError = _imageFiles.isEmpty;
      });
      widget.onImagesSelected(_imageFiles);
      widget.onValidationChanged(_imageFiles.isNotEmpty);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
      _showError = _imageFiles.isEmpty;
    });
    widget.onImagesSelected(_imageFiles);
    widget.onValidationChanged(_imageFiles.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _pickImages,
          child: DottedBorder(
            color: _showError ? Colors.red : Colors.blue,
            strokeWidth: 1,
            dashPattern: [4, 4],
            child: Container(
              height: 150,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 50,
                      color: _showError ? Colors.red : AppColors.primaryColor),
                  Text('browse',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          fontWeight: FontWeight.w500,
                          color: _showError
                              ? Colors.red
                              : AppColors.primaryColor)),
                  SizedBox(height: 1.5.h),
                  Text('Max 5 MB files are allowed',
                      style: TextStyle(
                          fontFamily: 'Maven Pro',
                          color: AppColors.lightTextColor,
                          fontSize: 4.w,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
        if (_showError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Please select at least one photo',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: 'Maven Pro',
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text('Only support .jpg and .png files',
            style: TextStyle(
                fontFamily: 'Maven Pro',
                color: AppColors.lightTextColor,
                fontSize: 4.w,
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 16),
        _imageFiles.isNotEmpty
            ? Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_imageFiles.length, (index) {
                  return Stack(
                    children: [
                      Image.file(
                        _imageFiles[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () => _removeImage(index),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              )
            : Container(),
      ],
    );
  }
}

class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  const DottedBorder({
    super.key,
    required this.child,
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashPattern: dashPattern,
      ),
      child: child,
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  _DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    double dashWidth = dashPattern[0];
    double dashSpace = dashPattern[1];

    double distance = 0;
    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        canvas.drawPath(
          measurePath.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class InvestmentThesisInput extends StatefulWidget {
  final List<HeaderField> headerFields;

  const InvestmentThesisInput({Key? key, required this.headerFields})
      : super(key: key);

  @override
  _InvestmentThesisInputState createState() => _InvestmentThesisInputState();
}

class _InvestmentThesisInputState extends State<InvestmentThesisInput> {
  @override
  void initState() {
    super.initState();
    _addHeaderField();
  }

  void _addHeaderField() {
    if (widget.headerFields.length < 3) {
      if (widget.headerFields.isEmpty || _isLastHeaderFilled()) {
        setState(() {
          widget.headerFields.add(HeaderField(
            key: UniqueKey(),
            onDelete: _removeHeaderField,
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Please fill the current header before adding a new one.'),
          ),
        );
      }
    }
  }

  bool _isLastHeaderFilled() {
    if (widget.headerFields.isEmpty) return true;
    HeaderField lastField = widget.headerFields.last;
    return lastField.headerController.text.isNotEmpty &&
        lastField.descriptionController.text.isNotEmpty;
  }

  void _removeHeaderField(HeaderField field) {
    setState(() {
      widget.headerFields.remove(field);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Investment Thesis',
            style: TextStyle(
                fontFamily: 'Maven Pro',
                color: const Color.fromRGBO(77, 76, 76, 1),
                fontSize: 4.w,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 1.h),
        Column(
          children: widget.headerFields,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: _addHeaderField,
              icon: const Icon(
                Icons.add,
                color: AppColors.primaryColor,
              ),
              label: Text(
                'Add Another Header',
                style: TextStyle(
                    fontFamily: 'Maven Pro',
                    color: AppColors.primaryColor,
                    fontSize: 4.w,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HeaderField extends StatelessWidget {
  final TextEditingController headerController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Function(HeaderField) onDelete;

  HeaderField({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: headerController,
                      maxLength: 18,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.delete_forever_outlined,
                              color: Colors.red),
                          onPressed: () {
                            onDelete(this);
                          },
                        ),
                        hintText: 'Type Your Header',
                        hintStyle: TextStyle(
                            fontFamily: 'Maven Pro',
                            color: const Color.fromRGBO(214, 214, 214, 1),
                            fontSize: 6.w,
                            fontWeight: FontWeight.w400),
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: descriptionController,
                maxLength: 200,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(
                      fontFamily: 'Maven Pro',
                      color: const Color.fromRGBO(214, 214, 214, 1),
                      fontSize: 5.w,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class UploadDocumentField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isSubmitted;
  final Function(File?) onFilePicked;

  const UploadDocumentField({
    Key? key,
    required this.label,
    required this.hint,
    required this.isSubmitted,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  _UploadDocumentFieldState createState() => _UploadDocumentFieldState();
}

class _UploadDocumentFieldState extends State<UploadDocumentField> {
  String? _fileName;
  bool _isUploading = false;
  String? _errorMessage;
  static const int _maxFileSize = 10 * 1024 * 1024; // 10 MB in bytes

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.first.path!);
      int fileSize = await file.length();

      if (fileSize > _maxFileSize) {
        setState(() {
          _errorMessage = 'File size exceeds 10 MB limit';
          _fileName = null;
        });
        widget.onFilePicked(null);
      } else {
        setState(() {
          _fileName = result.files.first.name;
          _errorMessage = null;
        });
        widget.onFilePicked(file);
      }
    }
  }

  void _removeFile() {
    setState(() {
      _fileName = null;
      _errorMessage = null;
    });
    widget.onFilePicked(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Maven Pro',
            color: const Color.fromRGBO(77, 76, 76, 1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _errorMessage != null
                    ? Colors.red
                    : const Color.fromARGB(255, 197, 197, 197),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Transform.rotate(
                  angle: 315 * (3.14159 / 180),
                  child: Icon(
                    Icons.attachment_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _fileName ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (_fileName != null)
                  InkWell(
                    onTap: _removeFile,
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_errorMessage != null || (widget.isSubmitted && _fileName == null))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage ?? 'This field is required',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        if (_fileName == null && _errorMessage == null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.hint,
              style: TextStyle(
                fontFamily: 'Maven Pro',
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}

typedef ControllerCallback = TextEditingController;

class PricingForm extends StatefulWidget {
  final TextEditingController amountcontroller;
  final List<BreakdownField> breakdownFields;

  PricingForm({
    Key? key,
    required this.amountcontroller,
    required this.breakdownFields,
  }) : super(key: key);

  @override
  _PricingFormState createState() => _PricingFormState();
}

class _PricingFormState extends State<PricingForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _addBreakdownField(); // Initialize with one breakdown field
  }

  void _addBreakdownField() {
    if (widget.breakdownFields.length < 15) {
      if (widget.breakdownFields.isEmpty || _isLastBreakdownFilled()) {
        setState(() {
          widget.breakdownFields.add(BreakdownField(
            key: UniqueKey(),
            onDelete: _removeBreakdownField,
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please fill the current breakdown before adding a new one.'),
          ),
        );
      }
    }
  }

  bool _isLastBreakdownFilled() {
    if (widget.breakdownFields.isEmpty) return true;
    BreakdownField lastField = widget.breakdownFields.last;
    return lastField.nameController.text.isNotEmpty &&
        lastField.amountController.text.isNotEmpty;
  }

  void _removeBreakdownField(BreakdownField field) {
    setState(() {
      widget.breakdownFields.remove(field);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Text(
              'Total Amount',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromRGBO(77, 76, 76, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: widget.amountcontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '₹',
                hintStyle: TextStyle(
                    fontFamily: 'Maven Pro',
                    color: Color.fromRGBO(214, 214, 214, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                prefix: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('₹ '),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Total amount is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Column(
              children: widget.breakdownFields,
            ),
            const SizedBox(height: 16),
            widget.breakdownFields.length < 15
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _addBreakdownField,
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: Text(
                          'Add Amount Breakdown',
                          style: TextStyle(
                              fontFamily: 'Maven Pro',
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class BreakdownField extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final Function(BreakdownField) onDelete;

  BreakdownField({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Amount Breakdown',
                  style: TextStyle(
                      fontFamily: 'Maven Pro',
                      color: AppColors.blackColor,
                      fontSize: 4.w,
                      fontWeight: FontWeight.w700),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    onDelete(this);
                  },
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Amount Type',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromRGBO(77, 76, 76, 1),
                  fontSize: 4.w,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Eg: construction cost or acquisition fee',
                hintStyle: TextStyle(
                    fontFamily: 'Maven Pro',
                    color: Color.fromRGBO(214, 214, 214, 1),
                    fontSize: 4.w,
                    fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount type is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Amount',
              style: TextStyle(
                  fontFamily: 'Maven Pro',
                  color: const Color.fromRGBO(77, 76, 76, 1),
                  fontSize: 4.w,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '₹',
                hintStyle: TextStyle(
                    fontFamily: 'Maven Pro',
                    color: Colors.black,
                    fontSize: 4.w,
                    fontWeight: FontWeight.w400),
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.5),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LocationField extends StatefulWidget {
  final Function(String, String, String) onLocationChanged;

  const LocationField({Key? key, required this.onLocationChanged})
      : super(key: key);

  @override
  _LocationFieldState createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  String _latitude = '';
  String _longitude = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = '${position.latitude}';
        _longitude = '${position.longitude}';
      });

      // Notify parent about the location change

      // Get the address from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _address = '${place.street}, ${place.locality}';
        // '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
      widget.onLocationChanged(_latitude, _longitude, _address);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
              fontFamily: 'Maven Pro',
              color: const Color.fromRGBO(77, 76, 76, 1),
              fontSize: 4.w,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.5)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 2.w,
                ),
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  _address,
                  style: TextStyle(
                      fontFamily: 'Maven Pro',
                      color: const Color.fromRGBO(77, 76, 76, 1),
                      fontSize: 16, // Adjust font size if necessary
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 2.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
