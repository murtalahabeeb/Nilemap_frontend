import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Widgets/admin_loc_view.dart';
import 'package:nilemap_frontend/Widgets/admin_room_view.dart';
import 'package:nilemap_frontend/Widgets/user_loc_view.dart';
import 'package:nilemap_frontend/Widgets/user_room_view.dart';

class ExpansionTileItems extends StatelessWidget {
  const ExpansionTileItems(this.entry, this.type);
  final Category entry;
  final String type;
  // Widget _buildTiles(Category root) {
  //   // if (root.children.isEmpty) {
  //   //   return ListTile(
  //   //     title: Text(root.title),
  //   //   );
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: PageStorageKey<Category>(entry),
        title: Text(entry.name),
        children: [
          Column(
            children: entry.locations.map<Widget>((loc) {
              return type == "user"
                  ? UserLocationView(loc)
                  : AdminLocationView(loc);
            }).toList(),
          ),
          Column(
            children: entry.rooms.map<Widget>((room) {
              return type == "user" ? UserRoomView(room) : AdminRoomView(room);
            }).toList(),
          ),
        ]);
  }
}
