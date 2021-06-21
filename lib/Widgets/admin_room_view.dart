import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Screens/edit_room.dart';
import 'package:provider/provider.dart';

class AdminRoomView extends StatelessWidget {
  final Room room;

  AdminRoomView(this.room);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Room name: ${room.room_name ?? "Untitled"}"),
      subtitle: Row(
        children: [
          Text("Room ${room.room_num}"),
          SizedBox(
            width: 15.0,
          ),
          Text("Building: ${room.location.name}")
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditRoom(room)),
                );
              }),
          Consumer<ServerNotifier>(builder: (_, serverNotifier, __) {
            return Consumer<VisibilityNotifier>(builder: (_, value, __) {
              return IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async {
                    value.isloading();
                    await serverNotifier.deleteroom(room);
                    serverNotifier.deleteroomfromcategory(room);
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
