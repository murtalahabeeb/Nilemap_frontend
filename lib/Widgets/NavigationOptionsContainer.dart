import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/MapNotifier.dart';
import 'package:provider/provider.dart';

class NavigationOptionsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapNotifier>(builder: (_, notifier, __) {
      return ToggleButtons(
        fillColor: Colors.transparent,
        children: <Widget>[
          Icon(
            Icons.directions_walk,
            semanticLabel: "Walking",
          ),
          Icon(
            Icons.pedal_bike,
            semanticLabel: "Cycling",
          ),
          Icon(
            Icons.car_repair,
            semanticLabel: "Driving",
          )
        ],
        onPressed: notifier.selectNavigationtMode,
        isSelected: notifier.isSelected,
        renderBorder: true,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      );
    });
  }
}
