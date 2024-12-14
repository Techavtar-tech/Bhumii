// // property_bloc.dart

// import 'package:bhumii/Models/Property_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// part 'property_event.dart';
// part 'property_state.dart';

// class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
//   PropertyBloc() : super(PropertyInitial()) {
//     on<LoadProperties>(_onLoadProperties);
//   }

//   Future<void> _onLoadProperties(LoadProperties event, Emitter<PropertyState> emit) async {
//     emit(PropertyLoading());
//     try {
//       final properties = await _fetchProperties();
//       print('Properties loaded: ${properties.length}'); // Debugging
//       emit(PropertyLoaded(properties: properties));
//     } catch (e) {
//       print('Error: $e'); // Debugging
//       emit(PropertyError(error: e.toString()));
//     }
//   }

//   Future<List<Property>> _fetchProperties() async {
//     final url = Uri.parse('https://secure-dog-27b6fd15ff.strapiapp.com/api/listings');
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaWF0IjoxNzIzNDcwMzkyLCJleHAiOjE3MjYwNjIzOTJ9.ZLrWsIcfi_RbKRSuGTRFrDbci5JhrAI1Oj94lcAYMvM',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print(data); // Debugging
//       return (data['data'] as List).map((e) => Property.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load properties');
//     }
//   }
// }
