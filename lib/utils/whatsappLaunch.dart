import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



// Function to launch WhatsApp
void launchWhatsApp(BuildContext context) async {
  final String phoneNumber = '7667244137';

  final url = 'https://wa.me/$phoneNumber';
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Provide feedback if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp.')),
      );
    }
  } catch (e) {
    // Provide feedback if an error occurs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
