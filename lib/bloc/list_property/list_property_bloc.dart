// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'list_property_event.dart';
// part 'list_property_state.dart';

// class ListPropertyBloc extends Bloc<ListPropertyEvent, ListPropertyState> {
//   ListPropertyBloc() : super(ListPropertyLoaded(selectedFiles: [], selectedImages: [])) {
//     on<PickFile>(_onPickFile);
//     on<PickImage>(_onPickImage);
//   }

//   void _onPickFile(PickFile event, Emitter<ListPropertyState> emit) {
//     if (state is ListPropertyLoaded) {
//       final updatedFiles = List<File>.from((state as ListPropertyLoaded).selectedFiles)..add(event.file);
//       emit(ListPropertyLoaded(selectedFiles: updatedFiles, selectedImages: (state as ListPropertyLoaded).selectedImages));
//     }
//   }

//   void _onPickImage(PickImage event, Emitter<ListPropertyState> emit) {
//     if (state is ListPropertyLoaded) {
//       final updatedImages = List<File>.from((state as ListPropertyLoaded).selectedImages)..add(event.image);
//       emit(ListPropertyLoaded(selectedFiles: (state as ListPropertyLoaded).selectedFiles, selectedImages: updatedImages));
//     }
//   }
// }
