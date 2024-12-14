// part of 'list_photo_bloc.dart';

// abstract class ListPhotoState extends Equatable {
//   const ListPhotoState();

//   @override
//   List<Object?> get props => [];
// }

// class ListPhotoInitial extends ListPhotoState {}

// class ListPhotoLoaded extends ListPhotoState {
//   final List<File> selectedFiles;
//   final List<File> selectedImages;

//   const ListPhotoLoaded({this.selectedFiles = const [], this.selectedImages = const []});

//   ListPhotoLoaded copyWith({List<File>? selectedFiles, List<File>? selectedImages}) {
//     return ListPhotoLoaded(
//       selectedFiles: selectedFiles ?? this.selectedFiles,
//       selectedImages: selectedImages ?? this.selectedImages,
//     );
//   }

//   @override
//   List<Object?> get props => [selectedFiles, selectedImages];
// }

// class ListPhotoLoading extends ListPhotoState {}

// class ListPhotoSuccess extends ListPhotoState {}

// class ListPhotoError extends ListPhotoState {
//   final String message;

//   const ListPhotoError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
