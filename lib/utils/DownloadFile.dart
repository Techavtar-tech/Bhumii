import 'package:flutter/material.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class DownloadWidget extends StatefulWidget {
  final String downloadUrl;

  DownloadWidget({required this.downloadUrl});

  @override
  _DownloadWidgetState createState() => _DownloadWidgetState();
}

class _DownloadWidgetState extends State<DownloadWidget> {
  final _flutterDownload = MediaDownload();

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  void _startDownload() async {
    await _flutterDownload.downloadMedia(context, widget.downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Can be empty as it's purely functional
  }
}
