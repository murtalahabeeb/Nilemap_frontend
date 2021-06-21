import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nilemap_frontend/Logic/MapNotifier.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  final Location destination;
  MapView([this.destination]);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<MapNotifier>(builder: (_, notifier, __) {
          notifier.destination = LatLng(double.parse(widget.destination.lat),
              double.parse(widget.destination.long));
          return GoogleMap(
              initialCameraPosition: notifier.initialLocation,
              myLocationEnabled: false,
              polylines: Set<Polyline>.of(notifier.polylines.values),
              // ...
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: notifier.markers != null
                  ? Set<Marker>.from(notifier.markers)
                  : null,
              circles: notifier.circles != null
                  ? Set<Circle>.from(notifier.circles)
                  : null,
              onMapCreated: (GoogleMapController controller) async {
                notifier.mapController = controller;
                if (await notifier.locationStatus() == null) {
                  notifier.imageData = await getMarker();
                  await notifier.getCurrentLocation();
                  await notifier.createPolylines();
                  notifier.getLiveLocation();
                } else {}
              });
        }),
      ],
    );
  }

  getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/navIcon.png");
    return byteData.buffer.asUint8List();
  }
}
