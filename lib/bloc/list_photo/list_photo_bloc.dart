// import 'dart:io';
// import 'dart:ui';

// import 'package:bhumii/utils/firebase_upload.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'list_photo_event.dart';
// part 'list_photo_state.dart';

// class ListPhotoBloc extends Bloc<ListPhotoEvent, ListPhotoState> {
//   ListPhotoBloc()
//       : super(ListPhotoLoaded(selectedFiles: [], selectedImages: [])) {
//     on<PickFile>(_onPickFile);
//     on<PickImage>(_onPickImage);
//     on<SubmitForm>(_onSubmitForm);
//   }

//   void _onPickFile(PickFile event, Emitter<ListPhotoState> emit) {
//     if (state is ListPhotoLoaded) {
//       final updatedFiles =
//           List<File>.from((state as ListPhotoLoaded).selectedFiles)
//             ..add(event.file);
//       emit((state as ListPhotoLoaded).copyWith(selectedFiles: updatedFiles));
//     }
//   }

//   void _onPickImage(PickImage event, Emitter<ListPhotoState> emit) {
//     if (state is ListPhotoLoaded) {
//       final updatedImages =
//           List<File>.from((state as ListPhotoLoaded).selectedImages)
//             ..add(event.image);
//       emit((state as ListPhotoLoaded).copyWith(selectedImages: updatedImages));
//     }
//   }

//   Future<void> _onSubmitForm(
//       SubmitForm event, Emitter<ListPhotoState> emit) async {
//     emit(ListPhotoLoading());
//     final selectedFiles = (state as ListPhotoLoaded).selectedFiles;
//     final selectedImages = (state as ListPhotoLoaded).selectedImages;

//     for (File file in selectedFiles) {
//       bool uploadSuccess = await uploadPDF(file);
//       if (!uploadSuccess) {
//         emit(ListPhotoError(
//             'Failed to upload ${file.path.split("/").last}. Please try again.'));
//         return;
//       }
//     }

//     for (File image in selectedImages) {
//       bool uploadImageSuccess = await uploadPhoto(image);
//       if (!uploadImageSuccess) {
//         emit(ListPhotoError(
//             'Failed to upload ${image.path.split("/").last}. Please try again.'));
//         return;
//       }
//     }

//     emit(ListPhotoSuccess());
//     event.onFinish();
//   }
// }
