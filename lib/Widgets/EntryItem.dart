import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Screens/Navigationpage.dart';

class ExpansionTileItems extends StatelessWidget {
  const ExpansionTileItems(this.entry);
  final Category entry;
  Widget _buildTiles(Category root) {
    // if (root.children.isEmpty) {
    //   return ListTile(
    //     title: Text(root.title),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        key: PageStorageKey<Category>(entry),
        title: Text(entry.name),
        children: [
          Column(
            children: entry.locations.map<Widget>((loc) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Navigation(loc)),
                    );
                  },
                  child: ListTile(
                    title: Text(loc.name),
                  ));
            }).toList(),
          ),
          Column(
            children: entry.rooms.map<Widget>((room) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Navigation(null, room)),
                    );
                  },
                  child: ListTile(
                    title: Text(room.room_name),
                    subtitle: Row(
                      children: [
                        Text("Room ${room.room_num}"),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(room.location.name)
                      ],
                    ),
                  ));
            }).toList(),
          )
        ]);
  }
}
