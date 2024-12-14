import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadPhoto(File photo, String name) async {
  try {
    await Firebase.initializeApp();
    String fileName = photo.path.split("/").last;

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('3/photos/$name/$fileName');

    await firebaseStorageRef.putFile(photo);
    String downloadURL = await firebaseStorageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error uploading photo: $e');
    return null;
  }
}

Future<String?> uploadPDF(File pdf, String name) async {
  try {
    await Firebase.initializeApp();
    String fileName = pdf.path.split("/").last;

    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('3/pdfs/$name/$fileName');

    await firebaseStorageRef.putFile(pdf);
    String downloadURL = await firebaseStorageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error uploading PDF: $e');
    return null;
  }
}

Future<List<String>> uploadPropertyPhotos(List<File> files) async {
  List<String> downloadUrls = [];
  try {
    final storageRef = FirebaseStorage.instance.ref().child('3/pdfs/photos');
    for (var file in files) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          file.uri.pathSegments.last;
      final uploadTask = storageRef.child(fileName).putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  } catch (e) {
    print('Error uploading files: $e');
    return [];
  }
}
