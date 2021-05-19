import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nilemap_frontend/Logic/MapNotifier.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Widgets/currentButton.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  Set<Marker> markers;
  Location destination;
  MapView(this.markers, [this.destination]);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<MapNotifier>(builder: (_, notifier, __) {
          return GoogleMap(
              initialCameraPosition: notifier.initialLocation,
              myLocationEnabled: true,
              polylines: Set<Polyline>.of(notifier.polylines.values),
              // ...
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: markers != null ? Set<Marker>.from(markers) : null,
              onMapCreated: (GoogleMapController controller) async {
                notifier.mapController = controller;
                await notifier.getCurrentLocation();
                await notifier.createPolylines(destination);
              });
        }),
      ],
    );
  }
}
