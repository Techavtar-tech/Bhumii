import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  // Your provided latitude and longitude
  static const LatLng defaultLocation =
      LatLng(18.591096693267563, 73.99964178555334);

  // Camera position using the default location
  static const CameraPosition defaultCameraLocation = CameraPosition(
    target: defaultLocation,
    zoom: 13.4746,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: defaultCameraLocation,
        markers: {
          Marker(
            markerId: MarkerId('defaultLocation'),
            position: defaultLocation,
          ),
        },
      ),
    );
  }
}
