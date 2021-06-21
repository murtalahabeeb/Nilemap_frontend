import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Screens/add_location.dart';
import 'package:provider/provider.dart';

class AdminLocationView extends StatelessWidget {
  final Location loc;
  AdminLocationView(this.loc);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Location: ${loc.name}"),
      subtitle: Text("Location ID: ${loc.id}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddLocation(loc)),
                );
              }),
          Consumer<ServerNotifier>(builder: (_, serverNotifier, __) {
            return Consumer<VisibilityNotifier>(builder: (_, value, __) {
              return IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async {
                    value.isloading();
                    await serverNotifier.deleteLocation(loc);
                    serverNotifier.deletelocationfromcategory(loc);
                    value.isloading();

                    //category.locations.remove(loc);
                  });
            });
          }),
        ],
      ),
    );
  }
}
