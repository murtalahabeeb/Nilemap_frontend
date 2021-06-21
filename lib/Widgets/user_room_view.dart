import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Screens/Navigationpage.dart';

class UserRoomView extends StatelessWidget {
  final Room room;
  UserRoomView(this.room);
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navigation(null, room)),
        );
      },
    );
  }
}
