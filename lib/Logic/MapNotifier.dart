import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/secrets.dart';
import 'dart:math' show cos, sqrt, asin;

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

  StreamSubscription<Position> positionStream;

  Location destination;

  //Position get destination => _destination;

  Set<Marker> markers = {};
  Marker destMarker;
  Marker userMarker;
  Set<Circle> circles = {};
  Circle circle;

  // Object for PolylinePoints
  PolylinePoints polylinePoints;

// List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting
// two points
  Map<PolylineId, Polyline> polylines = {};

// Create the polylines for showing the route between two places

  Uint8List imageData;

  List<bool> isSelected = [true, false, false];
  bool loading = false;
  double totalDistance = 0.0;
  String placeDistance;

  setDestMarker() {
    destMarker = Marker(
      markerId: MarkerId(
          LatLng(double.parse(destination.lat), double.parse(destination.long))
              .toString()),
      position:
          LatLng(double.parse(destination.lat), double.parse(destination.long)),
      infoWindow: InfoWindow(
          title: "title for now",
          snippet: "${destination.lat}, ${destination.long}"),
      icon: BitmapDescriptor.defaultMarker,
    );
    if (!markers.contains(destMarker)) {
      markers.add(destMarker);
    }
  }

  setUserMarker() {
    if (markers.contains(userMarker)) {
      markers.remove(userMarker);
      circles.remove(circle);
    }
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    userMarker = Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      draggable: false,
      rotation: currentPosition.heading,
      flat: true,
      anchor: Offset(0.5, 0.5),
      zIndex: 2,
      infoWindow: InfoWindow(
        title: "Current location",
        snippet: latLng.toString(),
      ),
      icon: BitmapDescriptor.fromBytes(imageData),
    );
    markers.add(userMarker);
    circle = Circle(
        circleId: CircleId("user"),
        radius: currentPosition.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latLng,
        strokeWidth: 5,
        fillColor: Colors.blue.withAlpha(70));
    circles.add(circle);
    print('circles${circles.length}');
  }

  createPolylines() async {
    try {
      // Initializing PolylinePoints
      polylinePoints = PolylinePoints();

      // Generating the list of coordinates to be used for
      // drawing the polylines
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Secrets.API_KEY, // Google Maps API Key
        PointLatLng(currentPosition.latitude, currentPosition.longitude),
        PointLatLng(
            double.parse(destination.lat), double.parse(destination.long)),
        travelMode: setNavigationtMode(isSelected),
      );

      // Adding the coordinates to the list
      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
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
      print(polylines.length);
      print("drawn");
    } catch (e) {
      // Defining an ID
      PolylineId id = PolylineId('poly');

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 20,
      );

      // Adding the polyline to the map

      polylines[id] = polyline;
      print(polylines.length);
      print("no network, error caught");
    }
  }

  //method to confirm permissions and locationservice

  Future<String> locationStatus() async {
    String locationError;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      locationError = 'Location services are disabled.';
      return locationError;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        locationError = 'Location permissions are denied';
        return locationError;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      locationError =
          'Location permissions are permanently denied, we cannot request permissions.';
      return locationError;
    }
    print(locationError);
    return locationError;
  }

  // Method for retrieving the current location from phone
  getCurrentLocation(Location location) async {
    destination = location;
    setDestMarker();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // Store the position in the variable
      _currentPosition = position;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      print('CURRENT POS: $_currentPosition');
      setUserMarker();

      // For moving the camera to current location
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );

      placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $placeDistance km');
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the current location from phone
  getLiveLocation() {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    int i = 0;
    positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
            .listen((Position position) async {
      _currentPosition = position;
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      i++;
      print('LIVE POS$i: $_currentPosition');
      setUserMarker();
      await createPolylines();
      placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $placeDistance km');
      notifyListeners();
      // For moving the camera to current location
      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(
      //       target: LatLng(position.latitude, position.longitude),
      //       zoom: 18.0,
      //     ),
      //   ),
      // );
    });
  }

  stopLiveLocation() {
    positionStream.cancel();
  }

  selectNavigationtMode(int index) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      if (buttonIndex == index) {
        isSelected[buttonIndex] = true;
      } else {
        isSelected[buttonIndex] = false;
      }
    }
    notifyListeners();
  }

  setNavigationtMode(List<bool> list) {
    TravelMode mode;
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      if (list[buttonIndex] == true && buttonIndex == 0) {
        mode = TravelMode.walking;
        print(mode);
        return mode;
      } else if (list[buttonIndex] == true && buttonIndex == 1) {
        mode = TravelMode.bicycling;
        print(mode);
        return mode;
      } else if (list[buttonIndex] == true && buttonIndex == 2) {
        mode = TravelMode.driving;
        print(mode);
        return mode;
      }
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
