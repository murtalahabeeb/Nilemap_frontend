import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Screens/edit_room.dart';
import 'package:provider/provider.dart';

class ShowRoom extends StatelessWidget {
  final Room room;
  final String type;
  ShowRoom({this.room, this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<Map<String, dynamic>>(builder: (_, notifier, __) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text("Room ${room.room_num.toString()}"),
              subtitle: Text(
                  'Room name: ${room.room_name == null ? "Untitled" : room.room_name.toUpperCase()}   -   Category: ${_category(notifier['categorized'], room) ?? "Uncategorized"}'),
            ),
            Divider(
              height: 1.0,
            ),
            ListTile(
              leading: type == "admin"
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditRoom(room)),
                              );
                            }),
                        Consumer<ServerNotifier>(
                            builder: (_, serverNotifier, __) {
                          return IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () async {
                                await serverNotifier.deleteroom(room);
                                serverNotifier.deleteroomfromcategory(room);

                                //category.locations.remove(loc);
                              });
                        }),
                      ],
                    )
                  : null,
              title: Text("${room.floor} floor - ${room.desc}"),
              subtitle: Text('Description'),
            ),
          ],
        );
      }),
    );
  }

  _category(List<Category> cate, Room room) {
    if (cate.firstWhere((element) => element.id == room.category_id,
            orElse: () => null) !=
        null) {
      return cate.firstWhere((element) => element.id == room.category_id).name;
    } else {
      return null;
    }
  }
}
