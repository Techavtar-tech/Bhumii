import 'package:flutter/material.dart';

void navigateToPage(context, page, ) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

void navigateToPageReplacement(BuildContext context, Widget page) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));
}

void navigateBack(BuildContext context) {
  Navigator.of(context).pop();
}
