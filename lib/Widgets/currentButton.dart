import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nilemap_frontend/Logic/MapNotifier.dart';
import 'package:provider/provider.dart';

class CurrentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: ClipOval(
          child: Material(
            color: Colors.orange[100], // button color
            child: Consumer<MapNotifier>(
              builder: (_, notifier, __) => InkWell(
                splashColor: Colors.orange, // inkwell color
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.my_location),
                ),
                onTap: () {
                  notifier.mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(
                          notifier.currentPosition.latitude,
                          notifier.currentPosition.longitude,
                        ),
                        zoom: 18.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
