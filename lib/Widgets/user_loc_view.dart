import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Screens/Navigationpage.dart';

class UserLocationView extends StatelessWidget {
  UserLocationView(this.loc);
  final Location loc;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Location: ${loc.name}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation(loc)),
        );
      },
    );
  }
}
