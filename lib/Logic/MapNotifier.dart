import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/secrets.dart';

class MapNotifier extends ChangeNotifier {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  CameraPosition get initialLocation => _initialLocation;
  // For controlling the view of the Map
  GoogleMapController mapController;
  //GoogleMapController get mapController => _mapController;

// For storing the current position
  Position _currentPosition;
  //get the value of current position
  Position get currentPosition => _currentPosition;

  //Position get destination => _destination;

  // Object for PolylinePoints
  PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting
// two points
  Map<PolylineId, Polyline> polylines = {};

// Create the polylines for showing the route between two places

  createPolylines(Location destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(
          double.parse(destination.lat), double.parse(destination.long)),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
    print("how many");
    notifyListeners();
  }

  // Method for retrieving the current location from phone
  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // Store the position in the variable
      _currentPosition = position;

      print('CURRENT POS: $_currentPosition');

      // For moving the camera to current location
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }
}
