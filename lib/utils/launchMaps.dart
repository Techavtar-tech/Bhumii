import 'dart:io';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

void launchDirections(dynamic lat, dynamic long) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$long';
    final String appleMapUrl =
        'https://maps.apple.com/?daddr=$lat,$long';
    if (Platform.isIOS) {
      UrlLauncher.launchUrl(Uri.parse(appleMapUrl),
          mode: LaunchMode.externalNonBrowserApplication);
    } else if (Platform.isAndroid) {
      UrlLauncher.launchUrl(Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      throw 'Unsupported platform';
    }
  }